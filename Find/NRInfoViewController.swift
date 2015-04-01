//
//  NRInfoViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/2/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

enum AvailabilityType {
    case Available
    case Taken
    case ComingSoon
    case Unavailable
}

class NRInfoViewController: UIViewController, NRInfoManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var result: NRResult!
    
    var manager: NRInfoManager!
    var info: NRInfo!
    
    var availabilityType: AvailabilityType! = AvailabilityType.Available
    
    var navigationBarView: NRInfoNavigationBarView!
    var previousScrollOffsetY: CGFloat!
    
    var tableView: UITableView!
    var actionButton: NRActionButton!
    
    init(result: NRResult!) {
        super.init(nibName: nil, bundle: nil)
        
        self.result = result
        
        manager = NRInfoManager()
        manager.communicator = NRInfoCommunicator()
        manager.communicator.delegate = manager
        manager.delegate = self
        
        startFetchingInfo()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        let cancelButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismissViewController")
        cancelButtonItem.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelButtonItem
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        
        if result.availability == "taken" {
            availabilityType = AvailabilityType.Taken
        } else if result.availability == "maybe" {
            availabilityType = AvailabilityType.ComingSoon
        }
        
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - 50)), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NRDefaultCell.self, forCellReuseIdentifier: "NRDefaultCell")
        tableView.registerClass(NRInfoViewRegistrarCell.self, forCellReuseIdentifier: "NRInfoViewRegistrarCell")
        tableView.backgroundColor = NRColor().domainrBackgroundGreyColor()
        navigationBarView = NRInfoNavigationBarView(frame:CGRectMake(0, 0, self.view.frame.size.width, 160), title: self.result.domain, subTitle: self.result.availability?.capitalizedString, labelType: availabilityType)
        tableView.tableHeaderView = navigationBarView
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(tableView.tableHeaderView!.frame.size.height, 0, 0, 0)
        tableView.stickyHeader = true
        tableView.tableFooterView = UIView(frame: CGRectZero)

        self.view.addSubview(tableView)
        
        let buttonFrame: CGRect = CGRectMake(0, self.view.frame.size.height - 50.0, self.view.frame.size.width, 50.0)
        actionButton = NRActionButton(frame: buttonFrame, buttonType: availabilityType)
        actionButton.addTarget(self, action: "presentAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(actionButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentAction() {

        let registerURL: NSURL! = NSURL(string: info.register_url!)

        let registerViewController: SVModalWebViewController = SVModalWebViewController(URL: registerURL)
        registerViewController.title = info.registrars?.objectAtIndex(0).valueForKey("name") as? String
        registerViewController.navigationBar.barTintColor = UIColor.whiteColor()
        registerViewController.navigationBar.translucent = false
        registerViewController.navigationBar.tintColor = NRColor().domainrBlueColor()

        self.presentViewController(registerViewController, animated: true, completion: nil)
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var sectionTotal: Int = 1
        
        if info != nil {
            if info.registrars != nil {
                sectionTotal++
            }
        }
        
        return sectionTotal
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int = 0
        
        if info != nil {
            if section == 0 {
                if info.whois_url != nil {
                    numberOfRows++
                }
                
                if info.tld?.valueForKey("wikipedia_url") != nil {
                   numberOfRows++
                }
                
                //Suggestions
                numberOfRows++;
            }
            
            if section == 1 {
                if info.registrars?.count < 5 {
                    numberOfRows = info.registrars!.count
                } else {
                    numberOfRows = 5
                }
            }
        }
        
        if section == tableView.numberOfSections()-1 {
            // cancel the perform request if there is another section
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "tableViewWillFinishLoading:", object: tableView)
            
            // create a perform request to call the didLoadRows method on the next event loop.
            self.callSelector("tableViewWillFinishLoading:", object:tableView, delay:0)
        }

        return numberOfRows
        
    }
    
    // #pragma mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height: CGFloat = 25.0
        
        if section == 1 {
            height = 28.0
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {
            cell = createDefaultCell(indexPath)
        } else if indexPath.section == 1 {
            cell = createRegistrarCell(indexPath)
        }
        
        cell.textLabel?.textColor = NRColor().domainrBlueColor()
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let whoisURL: NSURL! = NSURL(string: info.whois_url!)
                let whoisViewController: SVWebViewController = SVWebViewController(URL: whoisURL)
                whoisViewController.title = "Whois Info"
                whoisViewController.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
                whoisViewController.navigationController?.navigationBar.shadowImage = nil
                whoisViewController.navigationController?.navigationBar.translucent = false
                
                self.navigationController?.pushViewController(whoisViewController, animated: true)
                
            } else if indexPath.row == 1 {
                
                let wikipediaURL: NSURL! = NSURL(string: info.tld!.valueForKey("wikipedia_url") as String)
                let wikipediaViewController: SVWebViewController = SVWebViewController(URL: wikipediaURL)
                wikipediaViewController.title = "TLD Wikipedia Article"
                wikipediaViewController.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
                wikipediaViewController.navigationController?.navigationBar.shadowImage = nil
                wikipediaViewController.navigationController?.navigationBar.translucent = false
                self.navigationController?.pushViewController(wikipediaViewController, animated: true)
            
            }
        
        } else if indexPath.section == 1 {
            
            if indexPath.row >= 4 {
                
                let newArray: NSArray = info.registrars!.objectsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(4, info.registrars!.count-8))) as NSArray
                let registrarsViewController: NRRegistrarViewController = NRRegistrarViewController(registrars: newArray)
                registrarsViewController.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
                registrarsViewController.navigationController?.navigationBar.shadowImage = nil
                registrarsViewController.navigationController?.navigationBar.translucent = false

                self.navigationController?.pushViewController(registrarsViewController, animated: true)
            
            } else {
                
                let registrarURL: NSURL! = NSURL(string: info.registrars!.objectAtIndex(indexPath.row).valueForKey("register_url") as String)
                let registrarViewController: SVWebViewController = SVWebViewController(URL: registrarURL)
                registrarViewController.title = info.registrars!.objectAtIndex(indexPath.row).valueForKey("name") as? String
                registrarViewController.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
                registrarViewController.navigationController?.navigationBar.shadowImage = nil
                registrarViewController.navigationController?.navigationBar.translucent = false
                
                self.navigationController?.pushViewController(registrarViewController, animated: true)
                
            }
            
        }
        
    }
    
    func createDefaultCell(indexPath: NSIndexPath!) -> NRDefaultCell {
        
        var cell: NRDefaultCell? = tableView.dequeueReusableCellWithIdentifier("NRDefaultCell", forIndexPath: indexPath) as? NRDefaultCell
        
        if cell == nil {
            cell = NRDefaultCell(style: .Default, reuseIdentifier: "NRDefaultCell")
        }

        cell?.textLabel?.text = "Whois Info"
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if indexPath.row == 1 {
            cell?.textLabel?.text = "TLD Wikipedia Article"
        }

        return cell!
        
    }
    
    func createRegistrarCell(indexPath: NSIndexPath!) -> NRInfoViewRegistrarCell {
        
        var cell: NRInfoViewRegistrarCell? = tableView.dequeueReusableCellWithIdentifier("NRInfoViewRegistrarCell", forIndexPath: indexPath) as? NRInfoViewRegistrarCell
        
        if cell == nil {
            cell = NRInfoViewRegistrarCell(style: .Default, reuseIdentifier: "NRInfoViewRegistrarCell")
        }
        
        cell?.textLabel?.text = NSString(format: "View %d ", info.registrars!.count - 4) + "Others"
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        if indexPath.row < 4 {
            cell?.textLabel?.text = info.registrars!.objectAtIndex(indexPath.row).valueForKey("name") as NSString
        }
        
        return cell!
        
    }
    
    func tableViewWillFinishLoading(tableView: UITableView) {
//        println(tableView.contentSize.height)
//        println(UIScreen.mainScreen().bounds.height)
//        if tableView.contentSize.height < UIScreen.mainScreen().bounds.height {
//            tableView.scrollEnabled = false
//        } else {
//            tableView.scrollEnabled = true
//        }
        
    }
    
    // #pragma mark - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        resizeHeaderView(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        resizeHeaderView(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        resizeHeaderView(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        resizeHeaderView(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        resizeHeaderView(scrollView)
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeHeaderView(scrollView: UIScrollView) {
        
        if previousScrollOffsetY == nil {
            previousScrollOffsetY = scrollView.contentOffset.y
        }
        
        if scrollView.isEqual(tableView) {
            
            let velocity: CGFloat = scrollView.panGestureRecognizer.velocityInView(scrollView).y
            let offset: CGFloat = scrollView.contentOffset.y
            
            println(offset)
            
            if offset < 94.0 {
                tableView.tableHeaderView!.frame.size.height += (previousScrollOffsetY - scrollView.contentOffset.y)
                previousScrollOffsetY = offset
            } else {
                tableView.tableHeaderView!.frame.size.height = 64.0
                previousScrollOffsetY = 94.0
            }
            navigationBarView.centerElements()
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(tableView.tableHeaderView!.frame.size.height, 0, 0, 0)
        }
    }
}
