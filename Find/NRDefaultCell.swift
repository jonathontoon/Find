//
//  NRDefaultCell.swift
//  Find
//
//  Created by Jonathon Toon on 3/8/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRDefaultCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.textLabel?.textColor = NRColor().domainrRegularDarkGreyColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
        if (selected) {
            self.backgroundColor = NRColor().domainrTableViewCellSelectedColor()
        } else {
            self.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        
        if (highlighted) {
            self.backgroundColor = NRColor().domainrTableViewCellSelectedColor()
        } else {
            self.backgroundColor = UIColor.whiteColor()
        }
    }
    
}
