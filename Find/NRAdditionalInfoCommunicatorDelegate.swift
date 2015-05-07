//
//  NRAdditionalInfoCommunicatorDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRAdditionalInfoCommunicatorDelegate {
    
    func receivedAdditionalInfoJSON(objectNotation: NSData) -> Void
    func additionalInfoJSONFailedWithError(error: NSError) -> Void
}