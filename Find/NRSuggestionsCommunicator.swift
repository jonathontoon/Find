//
//  NRSuggestionsCommunicator.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

class NRSuggestionsCommunicator: NSObject {
    
    var delegate: NRSuggestionsCommunicatorDelegate!
    
    func getSuggestionsForDomain(query: String!) {
        
        let encodedString: String = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlAsString: String = String(format: "https://www.kimonolabs.com/api/ondemand/5kzxkxfy?apikey=e64b763681f140bec8391a4e8547d9dd&kimmodify=1&domain-name=%@", encodedString)
        println(urlAsString)
        
        let url: NSURL = NSURL(string: urlAsString)!
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue(), completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError?)  -> Void in
            
            if error != nil {
                self.delegate.domainSuggestionsJSONFailedWithError(error!)
            } else {
                self.delegate.receivedDomainSuggestionsJSON(data)
            }
            
        })
        
    }
}
