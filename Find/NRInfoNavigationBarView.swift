//
//  NRInfoNavigationBarView.swift
//  Find
//
//  Created by Jonathon Toon on 3/8/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoNavigationBarView: UIView {

    var titleString: String?
    var titleLabel: UILabel!
    
    var subTitleString: String?
    var subTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame:CGRect, title:String!, subTitle:String!) {
        super.init(frame: frame)
        
        self.backgroundColor = NRColor().domainrBackgroundBlackColor()
        
        titleString = title
        subTitleString = subTitle
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.clearColor()
        self.layer.backgroundColor = UIColor.blueColor().CGColor
        
        titleLabel = UILabel()
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 21.0)
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.layer.backgroundColor = UIColor.clearColor().CGColor
        titleLabel.frame.origin.x = self.frame.width/2 - (titleLabel.frame.width/2)
        self.addSubview(titleLabel)
        
        subTitle = UILabel()
        subTitle.text = subTitleString
        subTitle.textColor = UIColor.blackColor()
        subTitle.font = UIFont(name: "HelveticaNeue", size: 14.0)
        subTitle.sizeToFit()
        subTitle.backgroundColor = UIColor.clearColor()
        subTitle.layer.backgroundColor = UIColor.clearColor().CGColor
        subTitle.frame.origin.x = self.frame.width/2 - (subTitle.frame.width/2)
        subTitle.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height - 2.0
        self.addSubview(subTitle)
    }
    
}
