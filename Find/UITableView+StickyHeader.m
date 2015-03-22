//
//  UITableView+StickyHeader.m
//
//  Created by Pham Hoang Le (namanhams) on 4/2/15.
//  Copyright (c) 2015 Pham. All rights reserved.
//

#import "UITableView+StickyHeader.h"

#import <objc/runtime.h>
#import <objc/message.h>

void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

NSString *const keyPath = @"contentOffset";

@interface UITableViewStickyHeaderObserver : NSObject
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation UITableViewStickyHeaderObserver
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(self.tableView.tableHeaderView) {
        CGRect frame = self.tableView.tableHeaderView.frame;
        frame.origin.y = self.tableView.contentOffset.y;
        self.tableView.tableHeaderView.frame = frame;
    }
}
@end

@implementation UITableView (StickyHeader)

@dynamic stickyHeader;

+ (void) load {
    // Method swizzling
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            Swizzle([self class], @selector(layoutSubviews), @selector(stickyLayoutSubview));
            
            // ARC doesn't allow to have @selector(dealloc)
            // This is a clever trick to overcome that, learnt from here:
            // http://www.merowing.info/2012/03/automatic-removal-of-nsnotificationcenter-or-kvo-observers/#.VNHSwWSUc8Y
            Swizzle([self class], NSSelectorFromString(@"dealloc"), @selector(stickyDealloc));
        }
    });
    
}

const char*KeyStickyHeader = "StickyHeader";
const char*KeyStickyHeaderObserver = "StickyHeaderObserver";

- (void) setStickyHeader:(BOOL)sticky {
    if(sticky == [self stickyHeader])
        return;
    
    objc_setAssociatedObject(self, KeyStickyHeader, @(sticky), OBJC_ASSOCIATION_RETAIN);
    
    if(sticky) {
        UITableViewStickyHeaderObserver *observer = [[UITableViewStickyHeaderObserver alloc] init];
        observer.tableView = self;
        [self addObserver:observer
               forKeyPath:keyPath
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        
        objc_setAssociatedObject(self, KeyStickyHeaderObserver, observer, OBJC_ASSOCIATION_RETAIN);
    }
    else {
        UITableViewStickyHeaderObserver *observer = objc_getAssociatedObject(self, KeyStickyHeaderObserver);
        [self removeObserver:observer forKeyPath:keyPath];
        objc_setAssociatedObject(self, KeyStickyHeaderObserver, nil, OBJC_ASSOCIATION_RETAIN);
    }
}

- (BOOL) stickyHeader {
    NSNumber *isSticky = objc_getAssociatedObject(self, KeyStickyHeader);
    return [isSticky boolValue];
}

- (void) stickyLayoutSubview {
    if(self.tableHeaderView && [self stickyHeader]) {
        CGRect frame = self.tableHeaderView.frame;
        [self stickyLayoutSubview];
        self.tableHeaderView.frame = frame;
    }
    else
        [self stickyLayoutSubview];
}

- (void) stickyDealloc {
    self.stickyHeader = false; // we want to remove the observer
    [self stickyDealloc];
}
@end

