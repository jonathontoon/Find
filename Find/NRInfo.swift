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
    var whoisURL: NSURL?
    var registerURL: NSURL?
    
    struct tld {
        var domain: String?
        var domainIDNA: String?
        var wikipediaURL: NSURL?
        var ianaURL: NSURL?
    }
    
    struct registrars {
        var registrar: String?
        var name: String?
        var registerURL: NSURL?
    }
    
    var host: String?
    var path: String?
    var wwwURL: NSURL?
    var query: String?
    var subdomain: String?
    var domainIDNA: String?
    var availability: String?
}
