//
//  NRInfoViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/2/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoViewController: UIViewController, NRInfoManagerDelegate {

    var result: NRResult!
    
    var manager: NRInfoManager!
    var info: NRInfo!
    
    func initWithDomainResult(result: NRResult) {
        self.result = result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Info"
        self.view.backgroundColor = UIColor.redColor()
        
        manager = NRInfoManager()
        manager.communicator = NRInfoCommunicator()
        manager.communicator.delegate = manager
        manager.delegate = self
        
        startFetchingInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFetchingInfo() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        manager.fetchInfoForDomain(result.domain)
    }
    
    // #pragma mark - NRResultsManagerDelegate
    
    func didReceiveInfo(info: NRInfo!) {
        self.info = info

        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func fetchingInfoFailedWithError(error: NSError!) {
        NSLog("Error %@; %@", error, error.localizedDescription)
    }
    
}
