
//
//  NRModelBuilder.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRModelBuilder: NSObject {

    func getResultsFromJSON(objectNotation: NSData!, error: NSError?) -> NSMutableArray {
        
        let results: NSMutableArray = NSMutableArray()
        var error: NSError? = nil
        
        if let parsedObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(objectNotation, options: nil, error:&error) as? NSDictionary {

            let pulledResults: NSArray = parsedObject.valueForKey("results") as! NSArray
            
            for resultDic in pulledResults as! [NSDictionary] {
                let result: NRResult = NRResult()
                
                for object in resultDic {
                    
                    if result.respondsToSelector(NSSelectorFromString(object.key as! String)) {
                        result.setValue(object.value, forKey:object.key as! String)
                    }
                }
                
                results.addObject(result)
            }
            
        } else {
            println("Could not parse JSON: \(error!)")
        }

        return results;
    }
    
    func getInfoFromJSON(objectNotation: NSData!, error: NSError?) -> NRInfo {

        let info: NRInfo = NRInfo()
        var error: NSError? = nil
        
        if let parsedObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(objectNotation, options: nil, error:&error) as? NSDictionary {
            
            for object in parsedObject {
                if info.respondsToSelector(NSSelectorFromString(object.key as! String)) {
                    info.setValue(object.value, forKey:object.key as! String)
                }
            }
            
        } else {
            println("Could not parse JSON: \(error!)")
        }
        
        return info
    }
    
    func getSearchSuggestionsFromJSON(objectNotation: NSData!, error: NSError?) -> NSArray? {
        
        println(objectNotation)
        
        var searchSuggestions: NSArray!
        var error: NSError? = nil
        
        if let parsedObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(objectNotation, options: nil, error:&error) as? NSDictionary {
            
            println(parsedObject)
            searchSuggestions = parsedObject.objectForKey("results") as! NSArray
            
        } else {
            println("Could not parse JSON: \(error!)")
        }
        
        return searchSuggestions
    }
    
    func getAdditionalInfoFromJSON(objectNotation: NSData!, error: NSError?) -> NRAdditionalInfo? {

        let additionalInfo = NRAdditionalInfo()
        var error: NSError? = nil
        
        if let parsedObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(objectNotation, options: nil, error:&error) as? NSDictionary {

            for object in parsedObject {
                if additionalInfo.respondsToSelector(NSSelectorFromString(object.key as! String)) {
                    additionalInfo.setValue(object.value, forKey:object.key as! String)
                }
            }

        } else {
            println("Could not parse JSON: \(error!)")
        }
        
        return additionalInfo
    }
}
