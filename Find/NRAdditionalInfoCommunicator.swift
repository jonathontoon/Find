//
//  NRAdditionalInfoCommunicator.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

class NRAdditionalInfoCommunicator: NSObject {
    
    var delegate: NRAdditionalInfoCommunicatorDelegate!
    
    func getAdditionalInfoForDomain(domain: String!, searchedString: String!) {
        
        let urlAsString: String = String(format: "https://www.kimonolabs.com/api/ondemand/2mp3abs4?apikey=e64b763681f140bec8391a4e8547d9dd&kimmodify=1&kimpath1=%@&q=%@", domain, searchedString.stringByReplacingOccurrencesOfString(" ", withString: ""))
        
        let url: NSURL = NSURL(string: urlAsString)!
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue(), completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError?)  -> Void in
            
            if error != nil {
                self.delegate.additionalInfoJSONFailedWithError(error!)
            } else {
                self.delegate.receivedAdditionalInfoJSON(data)
            }
            
        })
        
    }
}
