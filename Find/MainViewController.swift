//
//  MainViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, NRResultsManagerDelegate {

    var results: NSArray?
    var manager: NRResultsManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = NRResultsManager()
        manager.communicator = NRResultsCommunicator()
        manager.communicator.delegate = manager
        manager.delegate = self

        manager.fetchResultsForQuery("keepitreal")
    }

    func startFetchingResults(notification: NSNotification) {
        manager.fetchResultsForQuery("keepitreal")
    }
    
    func didReceiveResults(results: NSArray!) {
        self.results = results
        println(self.results)
    }
    
    func fetchingResultsFailedWithError(error: NSError!) {
        NSLog("Error %@; %@", error, error.localizedDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

