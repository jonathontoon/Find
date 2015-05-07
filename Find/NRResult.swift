//
//  NRResult.swift
//  Find
//
//  Object for a returned domain query JSON
//  https://domainr.com/api/json/search?client_id=EXAMPLE&q=SEARCHQUERY
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRResult: NSObject {
 
    var searchedString: String?
    var domain: String?
    var tld: String?
    var register_url: String?
    var host: String?
    var path: String?
    var subdomain: String?
    var availability: String?
    
}