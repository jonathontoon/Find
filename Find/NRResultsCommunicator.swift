//
//  NRResultsCommunicator.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

class NRResultsCommunicator: NSObject {
    
    var delegate: NRResultsCommunicatorDelegate!
    
    func searchForDomainsThatContainQuery(query: NSString!) {
       
        let urlAsString: String = String(format: "https://api.domainr.com/v1/search?client_id=find&q=%@", query.stringByReplacingOccurrencesOfString(" ", withString: ""))
            
        let url: NSURL = NSURL(string: urlAsString)!
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue(), completionHandler: {
          (response: NSURLResponse!, data: NSData!, error: NSError?)  -> Void in
            
            if error != nil {
                self.delegate.domainSearchJSONFailedWithError(error!)
            } else {
                self.delegate.receivedDomainSearchJSON(data)
            }
            
        })
        
    }
}
