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
    
    func fetchAdditionalInfoForDomain(domain: String!, searchedString: String!) {
        communicator.getAdditionalInfoForDomain(domain!, searchedString: searchedString)
    }
    
    // #pragma mark - NRAdditionalInfoManagerDelegate
    func receivedAdditionalInfoJSON(objectNotation: NSData) {
        var localError: NSError?
        var additionalInfo: NRAdditionalInfo = NRModelBuilder().getAdditionalInfoFromJSON(objectNotation, error: &localError)!
        
        if localError != nil {
            self.delegate.fetchingAdditionalInfoFailedWithError(localError)
        } else {
            self.delegate.didReceiveAdditionalInfo(additionalInfo)
        }
        
    }
    
    func additionalInfoJSONFailedWithError(error: NSError) {
        self.delegate.fetchingAdditionalInfoFailedWithError(error)
    }
}

