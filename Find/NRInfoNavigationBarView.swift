//
//  NRInfoNavigationBarView.swift
//  Find
//
//  Created by Jonathon Toon on 3/8/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoNavigationBarView: UIView {

    var patternView: NRInfoNavigationBarPatternView!
    
    var titleString: String?
    var titleLabel: UILabel!
    
    var subTitleString: String?
    var subTitle: NRSubtitleLabel!
    
    var tldString: String?
    
    var type: AvailabilityType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame:CGRect, title:String!, subTitle:String!, labelType: AvailabilityType!, tld: String!) {
        super.init(frame: frame)
        
        self.backgroundColor = NRColor().domainrBackgroundBlackColor()
        
        titleString = title
        subTitleString = subTitle
        type = labelType
        tldString = tld
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        patternView = NRInfoNavigationBarPatternView(frame: CGRectMake(0, 0, self.frame.size.width, UIScreen.mainScreen().bounds.height), topLevelDomain: tldString)
        self.addSubview(patternView)
        
        titleLabel = UILabel()
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 25.0)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.layer.backgroundColor = UIColor.clearColor().CGColor
        titleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRectIntegral(titleLabel.frame)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.center = CGPointIntegral(CGPointMake(self.center.x, self.center.y - 12))
        self.addSubview(titleLabel)
        
        subTitle = NRSubtitleLabel()
        subTitle.text = subTitleString?.uppercaseString
        subTitle.textColor = UIColor.whiteColor()
        subTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 10.0)
        subTitle.backgroundColor = NRColor().domainrGreenColor()
        subTitle.layer.cornerRadius = 2.0
        subTitle.clipsToBounds = true
        subTitle.transform = CGAffineTransformMakeScale(1.0, 1.0)
        
        if type == AvailabilityType.Taken {
            subTitle.backgroundColor = NRColor().domainrBlueColor()
        }
        
        if type == AvailabilityType.Unavailable {
            subTitle.backgroundColor = NRColor().domainrRedColor()
        }
        
        subTitle.layer.backgroundColor = UIColor.clearColor().CGColor
        subTitle.sizeToFit()
        subTitle.frame = CGRectIntegral(subTitle.frame)
        subTitle.textAlignment = NSTextAlignment.Center
        subTitle.center = CGPointIntegral(CGPointMake(self.center.x, (self.bounds.size.height/2) + 17.0))
        
        self.addSubview(subTitle)

    }
    
    func centerElements() {

        let centerYOffset: CGFloat = mapCGFloatRange(self.frame.size.height, r1: 175.0, r2: 64.0, t1: 12.0, t2: -6.5)
        titleLabel.center = CGPointIntegral(CGPointMake(self.bounds.size.width/2, (self.bounds.size.height/2) - centerYOffset))
        
        var scale: CGFloat = mapCGFloatRange(self.frame.size.height, r1: 175.0, r2: 64.0, t1: 1.0, t2: 0.68)
        scale = scale < 1.0 ? scale : 1.0
        titleLabel.transform = CGAffineTransformMakeScale(scale, scale)

        subTitle.center = CGPointIntegral(CGPointMake(self.bounds.size.width/2, (self.bounds.size.height/2) + 17.0))
        
        var subScale: CGFloat = mapCGFloatRange(self.frame.size.height, r1: 175.0, r2: 64.0, t1: 1.0, t2: 0.5)
        subScale = subScale < 1.0 ? subScale : 1.0
        subTitle.transform = CGAffineTransformMakeScale(subScale, subScale)

        var subRadius: CGFloat = mapCGFloatRange(self.frame.size.height, r1: 175.0, r2: 64.0, t1: 2.0, t2: 0.2)
        subRadius = subRadius < 2.0 ? subRadius : 2.0
        subTitle.layer.cornerRadius = subRadius
        
        subTitle.alpha = mapCGFloatRange(self.frame.size.height, r1: 175.0, r2: 72.0, t1: 1.0, t2: 0.0)

    }
    
    // http://stackoverflow.com/a/6237034/553149
    func mapCGFloatRange(v:CGFloat, r1:CGFloat, r2:CGFloat, t1:CGFloat, t2:CGFloat) -> CGFloat {
    
        let norm: CGFloat = (v-r1)/(r2-r1)
        return (t1*(1-norm) + t2*norm)
    }
}
