//
//  NRInfoNavigationBarPatternView.swift
//  Find
//
//  Created by Jonathon Toon on 4/2/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoNavigationBarPatternView: UIView {

    var tldString: NSString!
    
    init(frame: CGRect!, topLevelDomain tldString: String!) {
        super.init(frame: frame)
        
        self.tldString = tldString
        
        let amount: Int = Int(round(self.frame.size.height/38.0))+1
        for i in 0..<amount {
            
            var yPosition: CGFloat = 0.0
            
            if i > 0 {
                let previousLabelFrame: CGRect = ((self.subviews as NSArray).objectAtIndex(i-1) as UIView).frame
                yPosition = (previousLabelFrame.origin.y + previousLabelFrame.size.height) + 14.0
            }
            
            self.addSubview(generateLabelLine(yPosition))
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateLabelLine(yPosition: CGFloat) -> UIView {
        
        let labelParentView: UIView = UIView(frame: CGRectMake(0, yPosition, 800.0, 18.0))
        
        var tldLabel: UILabel!

        for i in 0..<12
        {
           
            tldLabel = UILabel()
            tldLabel.text = self.tldString
            tldLabel.font = UIFont(name: "RockoUltraFLF", size: 18.0)
            tldLabel.textColor = UIColor.whiteColor()
            tldLabel.alpha = 0.05
            tldLabel.sizeToFit()
            
            if i > 0 {
                let previousLabelFrame: CGRect = ((labelParentView.subviews as NSArray).objectAtIndex(i-1) as UILabel).frame
                tldLabel.frame = CGRectMake((previousLabelFrame.origin.x + previousLabelFrame.size.width) + 20.0, 0, tldLabel.frame.size.width, tldLabel.frame.size.height)
            }
            
            labelParentView.addSubview(tldLabel)
        }
        
        labelParentView.center = CGPointIntegral(CGPointMake(self.center.x, labelParentView.center.y))
        
        return labelParentView
    }
}
