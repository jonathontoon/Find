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
        
        self.tableView.registerClass(NRInfoViewDefaultCell.self, forCellReuseIdentifier: "NRInfoViewDefaultCell")
        self.tableView.registerClass(NRInfoViewRegistrarCell.self, forCellReuseIdentifier: "NRInfoViewRegistrarCell")
        
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
        
        println(self.info)
        
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
        
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {

            cell = createDefaultCell(indexPath)
            
        } else if indexPath.section == 1 {
        
            cell = createRegistrarCell(indexPath)
        
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func createDefaultCell(indexPath: NSIndexPath!) -> NRInfoViewDefaultCell {
        
        var cell: NRInfoViewDefaultCell? = tableView.dequeueReusableCellWithIdentifier("NRInfoViewDefaultCell", forIndexPath: indexPath) as? NRInfoViewDefaultCell
        
        if cell == nil {
            cell = NRInfoViewDefaultCell(style: .Default, reuseIdentifier: "NRInfoViewDefaultCell")
        }
        
        cell?.title.text = "Whois Info"
        
        if indexPath.row == 1 {
            cell?.title.text = "TLD Wikipedia Article"
        }
        
        return cell!
        
    }
    
    func createRegistrarCell(indexPath: NSIndexPath!) -> NRInfoViewRegistrarCell {
        
        var cell: NRInfoViewRegistrarCell? = tableView.dequeueReusableCellWithIdentifier("NRInfoViewRegistrarCell", forIndexPath: indexPath) as? NRInfoViewRegistrarCell
        
        if cell == nil {
            cell = NRInfoViewRegistrarCell(style: .Default, reuseIdentifier: "NRInfoViewRegistrarCell")
        }
        
        println(info.registrars?.objectAtIndex(indexPath.row).name)
        
        cell?.title.text = info.registrars?.objectAtIndex(indexPath.row).name
        
        return cell!
        
    }
}
