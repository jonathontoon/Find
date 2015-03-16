//
//  NRInfo.swift
//  Find
//
//  Object for a returned domain JSON
//  https://domainr.com/api/json/info?client_id=EXAMPLE&q=DOMAIN
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfo: NSObject {
    
    var domain: String?
    var whois_url: String?
    var register_url: String?
    
    var tld: NSDictionary?
    var registrars: NSArray?

    var host: String?
    var path: String?
    var www_url: String?
    var query: String?
    var subdomain: String?
    var domain_idna: String?
    var availability: String?
    
    var is_idn: Bool! = false
    var alternatives: NSArray!
    
}
