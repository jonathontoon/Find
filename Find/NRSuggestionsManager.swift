//
//  NRSuggestionsManager.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRSuggestionsManager: NSObject, NRSuggestionsCommunicatorDelegate {
    
    var communicator: NRSuggestionsCommunicator!
    var delegate: NRSuggestionsManagerDelegate!
    
    func fetchSuggestionsForDomain(query: String!) {
        communicator.getSuggestionsForDomain(query!)
    }
    
    // #pragma mark - NRSuggestionsManagerDelegate
    func receivedDomainSuggestionsJSON(objectNotation: NSData) {
        var localError: NSError? = nil
        var suggestions: NSArray = NRModelBuilder().getSuggestionsFromJSON(objectNotation, error: localError)!
        
        if localError != nil {
            self.delegate.fetchingSuggestionsFailedWithError(localError)
        } else {
            self.delegate.didReceiveSuggestions(suggestions)
        }
        
    }
    
    func domainSuggestionsJSONFailedWithError(error: NSError) {
        self.delegate.fetchingSuggestionsFailedWithError(error)
    }
}

