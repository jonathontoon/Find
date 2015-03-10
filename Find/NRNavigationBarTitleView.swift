//
//  NRNavigationBarTitleView.swift
//  Find
//
//  Created by Jonathon Toon on 3/8/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRNavigationBarTitleView: UIView {

    var titleString: String!
    var titleLabel: UILabel!
    
    var subTitleString: String!
    var subTitle: UILabel!
    
    init(frame:CGRect, title:String!, subTitle:String!) {
        super.init(frame: frame)
        
        titleString = title
        subTitleString = subTitle
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.clearColor()
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        self.sizeToFit()
        
        titleLabel = UILabel()
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.layer.backgroundColor = UIColor.clearColor().CGColor
        titleLabel.frame.origin.x = self.frame.width/2 - (titleLabel.frame.width/2)
        titleLabel.frame.origin.y = 2.0
        self.addSubview(titleLabel)
        
        subTitle = UILabel()
        subTitle.text = subTitleString.uppercaseString
        subTitle.textColor = UIColor.blackColor()
        subTitle.font = UIFont(name: "HelveticaNeue", size: 10.0)
        subTitle.sizeToFit()
        subTitle.backgroundColor = UIColor.clearColor()
        subTitle.layer.backgroundColor = UIColor.clearColor().CGColor
        subTitle.frame.origin.x = self.frame.width/2 - (subTitle.frame.width/2)
        subTitle.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height + 2.0
        self.addSubview(subTitle)
    }
    
}
