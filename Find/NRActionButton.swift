//
//  NRActionButton.swift
//  Find
//
//  Created by Jonathon Toon on 3/10/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRActionButton: UIButton {

    init(frame: CGRect, buttonType: AvailabilityType) {
        super.init(frame: frame)
        
        println("######")
        println(buttonType == AvailabilityType.ComingSoon)
        
        if buttonType == AvailabilityType.Available {
            self.setTitle("Buy Now", forState: UIControlState.Normal)
            self.backgroundColor = NRColor().domainrGreenColor()
        } else if buttonType == AvailabilityType.Taken {
            self.setTitle("Make An Offer", forState: UIControlState.Normal)
            self.backgroundColor = NRColor().domainrBlueColor()
        } else if buttonType == AvailabilityType.ComingSoon {
            self.setTitle("Reserve For Free", forState: UIControlState.Normal)
            self.backgroundColor = NRColor().domainrGreenColor()
        }
        
        self.titleLabel?.textColor = UIColor.whiteColor()
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
