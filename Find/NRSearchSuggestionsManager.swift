//
//  NRSearchSuggestionsManager.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRSearchSuggestionsManager: NSObject, NRSearchSuggestionsCommunicatorDelegate {
    
    var communicator: NRSearchSuggestionsCommunicator!
    var delegate: NRSearchSuggestionsManagerDelegate!
    
    func fetchSearchSuggestionsForDomain(query: String!) {
        communicator.getSearchSuggestionsForDomain(query!)
    }
    
    // #pragma mark - NRSearchSuggestionsManagerDelegate
    func receivedSearchSuggestionsJSON(objectNotation: NSData) {
        var localError: NSError? = nil
        var suggestions: NSArray = NRModelBuilder().getSearchSuggestionsFromJSON(objectNotation, error: &localError)!
        
        if localError != nil {
            self.delegate.fetchingSearchSuggestionsFailedWithError(localError)
        } else {
            self.delegate.didReceiveSearchSuggestions(suggestions)
        }
        
    }
    
    func searchSuggestionsJSONFailedWithError(error: NSError) {
        self.delegate.fetchingSearchSuggestionsFailedWithError(error)
    }
}

