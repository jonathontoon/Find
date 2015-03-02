//
//  NRResultsManager.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRResultsManager: NSObject, NRResultsCommunicatorDelegate {

    var communicator: NRResultsCommunicator!
    var delegate: NRResultsManagerDelegate!

    func fetchResultsForQuery(query: String!) {
        communicator.searchForDomainsThatContainQuery(query!)
    }
    
    // #pragma mark - NRResultsManagerDelegate
    
    func receivedDomainSearchJSON(objectNotation: NSData) {
        var localError: NSError? = nil
        let results: NSArray = NRModelBuilder().getResultsFromJSON(objectNotation, error: localError)
        
        if localError != nil {
            self.delegate.fetchingResultsFailedWithError(localError)
        } else {
            self.delegate.didReceiveResults(results)
        }
        
    }
    
    func domainSearchJSONFailedWithError(error: NSError) {
        self.delegate.fetchingResultsFailedWithError(error)
    }
}
