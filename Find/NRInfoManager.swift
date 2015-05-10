//
//  NRInfoManager.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoManager: NSObject, NRInfoCommunicatorDelegate {
    
    var communicator: NRInfoCommunicator!
    var delegate: NRInfoManagerDelegate!
    
    func fetchInfoForDomain(query: String!) {
        communicator.getInfoForDomain(query!)
    }
    
    // #pragma mark - NRInfoManagerDelegate
    func receivedDomainInfoJSON(objectNotation: NSData) {
        var localError: NSError? = nil
        let info: NRInfo = NRModelBuilder().getInfoFromJSON(objectNotation, error: &localError)
        
        if localError != nil {
            self.delegate.fetchingInfoFailedWithError(localError)
        } else {
            self.delegate.didReceiveInfo(info)
        }
        
    }
    
    func domainInfoJSONFailedWithError(error: NSError) {
        self.delegate.fetchingInfoFailedWithError(error)
    }
}

