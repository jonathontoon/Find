//
//  NRInfoViewNavigationBar.swift
//  Find
//
//  Created by Jonathon Toon on 3/21/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoViewNavigationBar: UINavigationBar {

    override func drawRect(rect: CGRect) {
        
        var superRect: CGRect! = rect
        superRect.origin.y = 0
        superRect.size.height = 140.0
        
        self.frame = superRect

    }
    
}
