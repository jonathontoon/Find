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
            
            var yCenter: CGFloat = -70.0
            
            if i > 0 {
                let previousLabelCenter: CGPoint = ((self.subviews as NSArray).objectAtIndex(i-1) as! UIView).center
                let previousLabelFrame: CGRect = ((self.subviews as NSArray).objectAtIndex(i-1) as! UIView).frame
                yCenter = previousLabelCenter.y + 40.0
            }
            
            self.addSubview(generateLabelLine(yCenter))
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateLabelLine(yCenter: CGFloat) -> UIView {
        
        let labelParentView: UIView = UIView(frame: CGRectMake(0, 0, 800.0, 16.0))
        
        var tldLabel: UILabel!

        for i in 0..<20
        {
           
            tldLabel = UILabel()
            tldLabel.text = self.tldString.uppercaseString as String
            tldLabel.font = UIFont(name: "RockoUltraFLF", size: 14.0)
            tldLabel.textColor = UIColor.whiteColor()
            tldLabel.alpha = 0.03
            tldLabel.sizeToFit()
            
            if i > 0 {
                let previousLabelFrame: CGRect = ((labelParentView.subviews as NSArray).objectAtIndex(i-1) as! UILabel).frame
                tldLabel.frame = CGRectMake((previousLabelFrame.origin.x + previousLabelFrame.size.width) + 5.0, 0, tldLabel.frame.size.width, tldLabel.frame.size.height)
            }
            
            labelParentView.addSubview(tldLabel)
        }
        
        labelParentView.sizeToFit()
        labelParentView.layer.transform = CATransform3DMakeRotation(CGFloat(( -30.0 * M_PI ) / 180.0), 0, 0, 1);
        labelParentView.center = CGPointIntegral(CGPointMake(self.center.x, yCenter))
        
        return labelParentView
    }
}
