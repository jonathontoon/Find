//
//  NRAdditionalInfoManagerDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRAdditionalInfoManagerDelegate {
    
    func didReceiveAdditionalInfo(suggestions: NSArray!) -> Void
    func fetchingAdditionalInfoFailedWithError(error: NSError!) -> Void
    
}
