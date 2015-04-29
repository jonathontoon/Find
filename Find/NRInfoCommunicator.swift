//
//  NRInfoCommunicator.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

class NRInfoCommunicator: NSObject {
    
    var delegate: NRInfoCommunicatorDelegate!
    
    func getInfoForDomain(query: String!) {
        
        let urlAsString: String = String(format: "https://api.domainr.com/v1/info?client_id=find&q=%@", query)
        let url: NSURL = NSURL(string: urlAsString)!
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue(), completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError?)  -> Void in
            
            if error != nil {
                self.delegate.domainInfoJSONFailedWithError(error!)
            } else {
                self.delegate.receivedDomainInfoJSON(data)
            }
            
        })
        
    }
}
