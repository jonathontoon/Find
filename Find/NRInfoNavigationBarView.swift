//
//  NRInfoNavigationBarView.swift
//  Find
//
//  Created by Jonathon Toon on 3/8/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoNavigationBarView: UIView {

    var containerView: UIView!
    
    var titleString: String?
    var titleLabel: UILabel!
    
    var subTitleString: String?
    var subTitle: NRSubtitleLabel!
    
    var type: AvailabilityType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame:CGRect, title:String!, subTitle:String!, labelType: AvailabilityType!) {
        super.init(frame: frame)
        
        self.backgroundColor = NRColor().domainrBackgroundBlackColor()
        
        titleString = title
        subTitleString = subTitle
        type = labelType
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.clearColor()
        self.layer.backgroundColor = UIColor.blueColor().CGColor
        
        titleLabel = UILabel()
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.layer.backgroundColor = UIColor.clearColor().CGColor
        titleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRectIntegral(titleLabel.frame)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.center = CGPointIntegral(CGPointMake(self.center.x, self.center.y - 14))
        self.addSubview(titleLabel)
        
        subTitle = NRSubtitleLabel()
        subTitle.text = subTitleString?.uppercaseString
        subTitle.textColor = UIColor.whiteColor()
        subTitle.font = UIFont(name: "HelveticaNeue", size: 10.0)
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
        subTitle.center = CGPointIntegral(CGPointMake(self.center.x, self.center.y + 14))
        self.addSubview(subTitle)

    }
    
    func centerElements() {

        titleLabel.center = CGPointIntegral(CGPointMake(self.center.x, self.center.y - 14))
        
        let scale: CGFloat = self.frame.size.height < 160 ? mapCGFloatRange(self.frame.size.height, r1: 160.0, r2: 64.0, t1: 1.0, t2: 0.8095) : 1.0
        titleLabel.transform = CGAffineTransformMakeScale(scale, scale)

        subTitle.center = CGPointIntegral(CGPointMake(self.center.x, self.center.y + 14.0))
        
        let subScale: CGFloat = self.frame.size.height < 160 ? mapCGFloatRange(self.frame.size.height, r1: 160.0, r2: 64.0, t1: 1.0, t2: 0.8095) : 1.0
        subTitle.transform = CGAffineTransformMakeScale(subScale, subScale)

        subTitle.alpha = mapCGFloatRange(self.frame.size.height, r1: 100.0, r2: 64.0, t1: 1.0, t2: 0.0)
    }
    
    // http://stackoverflow.com/a/6237034/553149
    func mapCGFloatRange(v:CGFloat, r1:CGFloat, r2:CGFloat, t1:CGFloat, t2:CGFloat) -> CGFloat {
    
        let norm: CGFloat = (v-r1)/(r2-r1)
        return (t1*(1-norm) + t2*norm)
    }
}
