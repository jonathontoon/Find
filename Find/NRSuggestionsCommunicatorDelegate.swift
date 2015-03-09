//
//  NRSuggestionsCommunicatorDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRSuggestionsCommunicatorDelegate {
    
    func receivedDomainSuggestionsJSON(objectNotation: NSData) -> Void
    func domainSuggestionsJSONFailedWithError(error: NSError) -> Void
}