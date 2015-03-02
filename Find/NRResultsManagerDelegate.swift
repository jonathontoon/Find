//
//  NRResultsManagerDelegate.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

protocol NRResultsManagerDelegate {
    
    func didReceiveResults(results: NSArray!) -> Void
    func fetchingResultsFailedWithError(error: NSError!) -> Void

}
