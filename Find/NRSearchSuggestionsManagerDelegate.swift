//
//  NRSearchSuggestionsManagerDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRSearchSuggestionsManagerDelegate {
    
    func didReceiveSearchSuggestions(suggestions: NSArray!) -> Void
    func fetchingSearchSuggestionsFailedWithError(error: NSError!) -> Void
    
}
