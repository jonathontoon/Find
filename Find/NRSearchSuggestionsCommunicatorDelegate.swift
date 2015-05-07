//
//  NRSearchSuggestionsCommunicatorDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRSearchSuggestionsCommunicatorDelegate {
    
    func receivedSearchSuggestionsJSON(objectNotation: NSData) -> Void
    func searchSuggestionsJSONFailedWithError(error: NSError) -> Void
}