//
//  NRInfoViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/2/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRInfoViewController: UITableViewController, NRInfoManagerDelegate {

    var result: NRResult!
    
    var manager: NRInfoManager!
    var info: NRInfo!
    
    func initWithDomainResult(result: NRResult) {
        self.result = result
        
        manager = NRInfoManager()
        manager.communicator = NRInfoCommunicator()
        manager.communicator.delegate = manager
        manager.delegate = self
        
        startFetchingInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButtonItem: UIBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
        
        let subTitleView: NRNavigationBarTitleView = NRNavigationBarTitleView(frame:CGRectMake(-100, 0, 200, self.navigationController!.navigationBar.frame.size.height), title: self.result.domain, subTitle: self.result.availability)
        self.navigationItem.titleView = subTitleView
        self.navigationItem.titleView?.backgroundColor = UIColor.clearColor()
        self.navigationItem.titleView?.layer.backgroundColor = UIColor.clearColor().CGColor
        
        self.view.backgroundColor = UIColor.redColor()
        
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
            self.tableView.reloadData()
        });
    }
    
    func fetchingInfoFailedWithError(error: NSError!) {
        NSLog("Error %@; %@", error, error.localizedDescription)
    }

    // #pragma mark - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var sectionTotal: Int = 1
        
        if info != nil {
            if info.registrars != nil {
                sectionTotal++
            }
        }
        
        return sectionTotal
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int = 0
        
        if info != nil {
            if section == 0 {
                if info.whois_url != nil {
                    numberOfRows++
                }
                
                if info.tld?.valueForKey("wikipedia_url") != nil {
                   numberOfRows++
                }
            }
            
            if section == 1 {
                if info.registrars?.count < 5 {
                    numberOfRows = info.registrars!.count
                } else {
                    numberOfRows = 6
                }
            }
        }
        
        return numberOfRows
        
    }
    
    // #pragma mark - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height: CGFloat = 25.0
        
        if section == 1 {
            height = 45.0
        }
        
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        var cell: NRResultCell! = tableView.dequeueReusableCellWithIdentifier(resultsTableViewCellIdentifier) as NRResultCell
//        
//        if cell == nil {
//            cell = NRResultCell(style: .Default, reuseIdentifier: resultsTableViewCellIdentifier)
//        }
//        
//        println((results!.objectAtIndex(indexPath.row) as NRResult).availability)
//        
//        cell.textLabel?.text = (results!.objectAtIndex(indexPath.row) as NRResult).domain! + " " + (results!.objectAtIndex(indexPath.row) as NRResult).availability!
//        
        return UITableViewCell()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
