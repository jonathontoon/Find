//
//  NRSubtitleLabel.swift
//  Find
//
//  Created by Jonathon Toon on 3/26/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRSubtitleLabel: UILabel {

    override func sizeThatFits(size: CGSize) -> CGSize {
        let size: CGSize = super.sizeThatFits(size)
        return CGSizeMake(size.width + 10, size.height + 4);
    }
    
}
