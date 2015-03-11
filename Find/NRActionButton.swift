//
//  NRActionButton.swift
//  Find
//
//  Created by Jonathon Toon on 3/10/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

enum ButtonType {
    case Available
    case Taken
    case ComingSoon
}

class NRActionButton: UIButton {

    init(frame: CGRect, buttonType: ButtonType) {
        super.init(frame: frame)
        
        if buttonType == ButtonType.Available {
            self.titleLabel?.text = "Buy Now"
            self.backgroundColor = UIColor.greenColor()
        } else if buttonType == ButtonType.Taken {
            self.titleLabel?.text = "Make An Offer"
            self.backgroundColor = UIColor.blueColor()
        } else if buttonType == ButtonType.ComingSoon {
            self.titleLabel?.text = "Reserve For Free"
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
