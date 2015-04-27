//
//  NRAdditionalInfoManager.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRAdditionalInfoManager: NSObject, NRAdditionalInfoCommunicatorDelegate {
    
    var communicator: NRAdditionalInfoCommunicator!
    var delegate: NRAdditionalInfoManagerDelegate!
    
    func fetchAdditionalInfoForDomain(query: String!) {
        communicator.getAdditionalInfoForDomain(query!)
    }
    
    // #pragma mark - NRAdditionalInfoManagerDelegate
    func receivedAdditionalInfoJSON(objectNotation: NSData) {
        var localError: NSError? = nil
        var suggestions: NSArray = NRModelBuilder().getAdditionalInfoFromJSON(objectNotation, error: localError)!
        
        if localError != nil {
            self.delegate.fetchingAdditionalInfoFailedWithError(localError)
        } else {
            self.delegate.didReceiveAdditionalInfo(suggestions)
        }
        
    }
    
    func additionalInfoJSONFailedWithError(error: NSError) {
        self.delegate.fetchingAdditionalInfoFailedWithError(error)
    }
}

