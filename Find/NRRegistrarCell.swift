//
//  NRRegistrarCell.swift
//  Find
//
//  Created by Jonathon Toon on 3/8/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRRegistrarCell: NRDomainCell {
 
    var cellSubTitle: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        
        cellTitle = UILabel(frame: CGRectMake(15.0, 0, 100.0, 17.0))
        cellTitle.center.y = round(self.contentView.center.y)
        cellTitle.textColor = NRColor().domainrRegularDarkGreyColor()
        self.contentView.addSubview(cellTitle)
        cellTitle.frame = CGRectIntegral(cellTitle.frame)
        
        cellSubTitle = UILabel(frame: CGRectMake(60.0, 0, 50.0, 12.0))
        cellSubTitle.center.y = round(self.contentView.center.y)
        cellSubTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        cellSubTitle.textColor = NRColor().domainrGreenColor()
        cellSubTitle.textAlignment = NSTextAlignment.Right
        self.contentView.addSubview(cellSubTitle)
        cellSubTitle.frame = CGRectIntegral(cellSubTitle.frame)
    }
    
    func setTextLabels(title: String!, subTitle: String?) {
        super.setTextLabel(title)
        
        if subTitle != nil {
            cellSubTitle.text = subTitle!.uppercaseString
            cellSubTitle.sizeToFit()
            cellSubTitle.frame = CGRectMake(60.0, 0, cellSubTitle.frame.size.width, cellSubTitle.frame.size.height)
            cellSubTitle.center.y = round(self.contentView.center.y)
            cellSubTitle.frame = CGRectIntegral(cellSubTitle.frame)
        } else {
            cellSubTitle.removeFromSuperview()
        }
    }
    
    override func prepareForReuse() {
        cellTitle.removeFromSuperview()
        cellTitle = nil
        
        cellSubTitle.removeFromSuperview()
        cellSubTitle = nil
    }
    
}
