//
//  NRDomainCell.swift
//  Find
//
//  Created by Jonathon Toon on 4/29/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRDomainCell: NRDefaultCell {

    var status: UIView!
    var cellTitle: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func addViews() {
        status = UIView(frame: CGRectMake(15.0, 0, 12.0, 12.0))
        status.layer.cornerRadius = 6.0
        
        status.center.y = round(self.contentView.center.y)
        self.contentView.addSubview(status)
        status.frame = CGRectIntegral(status.frame)
        
        cellTitle = UILabel(frame: CGRectMake(34.0, 0, 100.0, 17.0))
        cellTitle.center.y = round(self.contentView.center.y)
        cellTitle.textColor = NRColor().domainrRegularDarkGreyColor()
        self.contentView.addSubview(cellTitle)
        cellTitle.frame = CGRectIntegral(cellTitle.frame)
    }
    
    func setAvailability(availability: String!) {
        
        status.backgroundColor = NRColor().domainrListIconGreyColor()
        
        if (availability as NSString).rangeOfString("available").location != NSNotFound && (availability as NSString).rangeOfString("unavailable").location == NSNotFound {
            status.backgroundColor = NRColor().domainrGreenColor()
        } else if (availability as NSString).rangeOfString("maybe").location != NSNotFound || (availability as NSString).rangeOfString("coming soon").location != NSNotFound {
            status.layer.backgroundColor = UIColor.clearColor().CGColor
            status.layer.borderColor = NRColor().domainrGreenColor().CGColor
            status.layer.borderWidth = 1.0
        } else if (availability as NSString).rangeOfString("taken").location != NSNotFound {
            status.backgroundColor = NRColor().domainrBlueColor()
        } else if (availability as NSString).rangeOfString("unavailable").location != NSNotFound {
            status.backgroundColor = NRColor().domainrRedColor()
        }
    }
    
    func setTextLabel(title: String!) {
        var firstWord: NSString = (title as NSString).substringToIndex(1).capitalizedString
        cellTitle.text = (title as NSString).stringByReplacingCharactersInRange(NSMakeRange(0, 1), withString: firstWord as String)
        cellTitle.sizeToFit()
        cellTitle.frame = CGRectMake(34.0, 0, cellTitle.frame.size.width, cellTitle.frame.size.height)
        cellTitle.center.y = round(self.contentView.center.y)
        cellTitle.frame = CGRectIntegral(cellTitle.frame)
    }
    
    override func prepareForReuse() {
        status.removeFromSuperview()
        cellTitle.removeFromSuperview()
        status = nil
        cellTitle = nil
    }
    
}
