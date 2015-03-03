//
//  NRInfoCommunicatorDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRInfoCommunicatorDelegate {
    
    func receivedDomainInfoJSON(objectNotation: NSData) -> Void
    func domainInfoJSONFailedWithError(error: NSError) -> Void
}