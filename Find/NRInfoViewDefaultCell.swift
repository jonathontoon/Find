//
//  NRInfoViewDefaultCell.swift
//  Find
//
//  Created by Jonathon Toon on 3/8/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoViewDefaultCell: UITableViewCell {

    var title: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title = UILabel(frame: CGRectMake(15.0, 0 , 225.0, 45.0))
        title.backgroundColor = UIColor.yellowColor()
        self.contentView.addSubview(title)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
