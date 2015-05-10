
//
//  NRModelBuilder.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRModelBuilder: NSObject {

    func getResultsFromJSON(objectNotation: NSData!, error: NSErrorPointer!) -> NSMutableArray {
        
        let results: NSMutableArray = NSMutableArray()
        let localError: NSErrorPointer = error
        
        if let parsedObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(objectNotation, options: nil, error: localError) as? NSDictionary {

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
            println("Could not parse JSON: \(localError)")
        }

        return results;
    }
    
    func getInfoFromJSON(objectNotation: NSData!, error: NSErrorPointer!) -> NRInfo {

        let info: NRInfo = NRInfo()
        let localError: NSErrorPointer = error

        if let parsedObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(objectNotation, options: nil, error: localError) as? NSDictionary {
            
            for object in parsedObject {
                if info.respondsToSelector(NSSelectorFromString(object.key as! String)) {
                    info.setValue(object.value, forKey:object.key as! String)
                }
            }
            
        } else {
            println("Could not parse JSON: \(localError)")
        }
        
        return info
    }
    
    func getSearchSuggestionsFromJSON(objectNotation: NSData!, error: NSErrorPointer!) -> NSArray? {
        
        println(objectNotation)
        
        var searchSuggestions: NSArray!
        let localError: NSErrorPointer = error
  
        if let parsedObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(objectNotation, options: nil, error: localError) as? NSDictionary {
            
            println(parsedObject)
            searchSuggestions = parsedObject.objectForKey("results") as! NSArray
            
        } else {
            println("Could not parse JSON: \(error)")
        }
        
        return searchSuggestions
    }
    
    func getAdditionalInfoFromJSON(objectNotation: NSData!, error: NSErrorPointer!) -> NRAdditionalInfo? {

        let additionalInfo = NRAdditionalInfo()
        let localError: NSErrorPointer = error
        
        if let parsedObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(objectNotation, options: nil, error: localError) as? NSDictionary {

            for object in parsedObject {
                if additionalInfo.respondsToSelector(NSSelectorFromString(object.key as! String)) {
                    additionalInfo.setValue(object.value, forKey:object.key as! String)
                }
            }

        } else {
            println("Could not parse JSON: \(localError)")
        }
        
        return additionalInfo
    }
}
