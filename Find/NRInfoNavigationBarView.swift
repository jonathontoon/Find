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
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.layer.backgroundColor = UIColor.clearColor().CGColor
        titleLabel.frame.origin.x = round(self.frame.width/2 - (titleLabel.frame.width/2))
        titleLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(titleLabel)
        
        subTitle = NRSubtitleLabel()
        subTitle.text = subTitleString?.uppercaseString
        subTitle.textColor = UIColor.whiteColor()
        subTitle.font = UIFont(name: "HelveticaNeue", size: 10.0)
        subTitle.backgroundColor = NRColor().domainrGreenColor()
        subTitle.textAlignment = NSTextAlignment.Center
        subTitle.layer.cornerRadius = 2.0
        subTitle.clipsToBounds = true
        subTitle.sizeToFit()
        
        if type == AvailabilityType.Taken {
            subTitle.backgroundColor = NRColor().domainrBlueColor()
        }
        
        if type == AvailabilityType.Unavailable {
            subTitle.backgroundColor = NRColor().domainrRedColor()
        }
        
        subTitle.layer.backgroundColor = UIColor.clearColor().CGColor
        subTitle.frame.origin.x = round(self.frame.width/2 - (subTitle.frame.width/2))
        self.addSubview(subTitle)
        
        centerElements()
    }
    
    func centerElements() {

        println(self.frame.size.height)
        
        var fontSize: CGFloat = mapCGFloatRange(self.frame.size.height, r1: 140.0, r2: 100.0, t1: 22.0, t2: 17.0)
        
        if fontSize > 22.0 {
            fontSize = 22.0
        } else if fontSize < 17.0 {
            fontSize = 17.0
        }
        
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: fontSize)
        titleLabel.frame.origin.x = round(self.frame.width/2 - (titleLabel.frame.width/2))
        titleLabel.frame.origin.y = round((self.frame.size.height/2 - titleLabel.frame.height/2) - 8.0)
        
        subTitle.frame.origin.y = round(titleLabel.frame.origin.y + titleLabel.frame.size.height + 5.0)
        
        subTitle.alpha = mapCGFloatRange(self.frame.size.height, r1: 140.0, r2: 100.0, t1: 1.0, t2: 0.0)
    }
    
    // http://stackoverflow.com/a/6237034/553149
    func mapCGFloatRange(v:CGFloat, r1:CGFloat, r2:CGFloat, t1:CGFloat, t2:CGFloat) -> CGFloat {
    
        let norm: CGFloat = (v-r1)/(r2-r1)
        return (t1*(1-norm) + t2*norm)
    }
}
