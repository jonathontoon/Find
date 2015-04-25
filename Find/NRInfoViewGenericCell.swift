//
//  NRInfoViewGenericCell.swift
//  Find
//
//  Created by Jonathon Toon on 4/13/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoViewGenericCell: NRDefaultCell {

    var icon: UIImageView!
    var cellTitle: UILabel!

    convenience init(title: String!){
        self.init(style: .Default, reuseIdentifier: nil)
        addViews(title)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func addViews(title: String!) {
        cellTitle = UILabel()
        cellTitle.text = title
        cellTitle.textColor = NRColor().domainrRegularDarkGreyColor()
        cellTitle.sizeToFit()
        cellTitle.frame = CGRectMake(50.0, 0, cellTitle.frame.size.width, cellTitle.frame.size.height)
        cellTitle.center.y = self.contentView.center.y
        self.contentView.addSubview(cellTitle)
        
        icon = UIImageView(frame: CGRectMake(15.0, 0, 20.0, 20.0))
        if title == "Whois Info" {
            icon.image = UIImage(named: "whoisInfo")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        } else if title == "TLD Wikipedia Article" {
            icon.image = UIImage(named: "tldArticle")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        } else {
            icon.image = UIImage(named: "alternativeDomains")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        icon.tintColor = NRColor().domainrBlueColor()
        icon.contentMode = UIViewContentMode.ScaleAspectFit
        icon.center.y = round(self.contentView.center.y)
        self.contentView.addSubview(icon)
    }
    
}
