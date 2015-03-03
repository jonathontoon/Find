//
//  NRInfoManagerDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRInfoManagerDelegate {
    
    func didReceiveInfo(info: NRInfo!) -> Void
    func fetchingInfoFailedWithError(error: NSError!) -> Void
    
}
