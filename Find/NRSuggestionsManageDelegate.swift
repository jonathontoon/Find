//
//  NRSuggestionsManagerDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRSuggestionsManagerDelegate {
    
    func didReceiveSuggestions(suggestions: NSArray!) -> Void
    func fetchingSuggestionsFailedWithError(error: NSError!) -> Void
    
}
