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

class NRInfoViewController: UIViewController, NRInfoManagerDelegate, NRAdditionalInfoManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    var activityIndicatorView: NRActivityIndicatorView!
    
    var result: NRResult!
    
    var infoManager: NRInfoManager!
    var info: NRInfo!
    
    var additionalInfoManager: NRAdditionalInfoManager!
    var additionalInfo: NRAdditionalInfo!
    
    var availabilityType: AvailabilityType! = AvailabilityType.Available
    
    var navigationBarView: NRInfoNavigationBarView!
    var previousScrollOffsetY: CGFloat!
    
    var newNavigationBar: UINavigationBar!
    
    var tableView: UITableView!
    var actionButton: NRActionButton!
    
    init(result: NRResult!) {
        super.init(nibName: nil, bundle: nil)
               self.result = result
        
        infoManager = NRInfoManager()
        infoManager.communicator = NRInfoCommunicator()
        infoManager.communicator.delegate = infoManager
        infoManager.delegate = self
        
        additionalInfoManager = NRAdditionalInfoManager()
        additionalInfoManager.communicator = NRAdditionalInfoCommunicator()
        additionalInfoManager.communicator.delegate = additionalInfoManager
        additionalInfoManager.delegate = self
        
        startFetchingInfo()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        styleNavigationBar()
        self.navigationController!.interactivePopGestureRecognizer.delegate = self
        
        if  UIApplication.sharedApplication().statusBarStyle != .LightContent {
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        } else {
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        }
        
        var selection: NSIndexPath? = self.tableView?.indexPathForSelectedRow()
        if (selection != nil) {
            self.tableView.deselectRowAtIndexPath(selection!, animated:true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NRInfoViewCell.self, forCellReuseIdentifier: "NRInfoViewCell")
        tableView.registerClass(NRRegistrarCell.self, forCellReuseIdentifier: "NRRegistrarCell")
        tableView.registerClass(NRDomainCell.self, forCellReuseIdentifier: "NRDomainCell")
        tableView.backgroundColor = NRColor().domainrBackgroundGreyColor()
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 175.0))
        tableView.tableHeaderView!.backgroundColor = NRColor().domainrBackgroundBlackColor()
        tableView.tableHeaderView!.layer.zPosition = 100
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(tableView.tableHeaderView!.frame.size.height, 0, 0, 0)
        tableView.stickyHeader = true
        tableView.separatorColor = NRColor().domairTableViewSeparatorBorder()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.scrollEnabled = false
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
       
        self.view.addSubview(tableView)
        
        self.activityIndicatorView = NRActivityIndicatorView(image: UIImage(named: "activityIndicator")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        self.activityIndicatorView.center = CGPointIntegral(self.view.center)
        self.activityIndicatorView.tintColor = NRColor().domainrBlueColor()
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func styleNavigationBar() {
        
        if newNavigationBar == nil  {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        
            newNavigationBar = UINavigationBar(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0))
            newNavigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            newNavigationBar.shadowImage = UIImage()
            newNavigationBar.translucent = true
            newNavigationBar.tintColor = UIColor.whiteColor()
            newNavigationBar.tag = 69
            
            let titleItem = UINavigationItem()
            
            let cancelButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButton")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Plain, target: self, action: "popViewController")
            titleItem.leftBarButtonItem = cancelButtonItem
            
            newNavigationBar.setItems([titleItem], animated: false)
            
            self.view.addSubview(newNavigationBar)
        }
    }
    
    func reloadViews() {
        
        self.activityIndicatorView.removeFromSuperview()
        
        result.availability = info.availability
        availabilityType = AvailabilityType.Available
        
        if result.availability == "taken" {
            availabilityType = AvailabilityType.Taken
        } else if result.availability == "Coming Soon" || result.availability == "maybe" {
            availabilityType = AvailabilityType.ComingSoon
        } else if result.availability == "unavailable" {
            availabilityType = AvailabilityType.Unavailable
        }
        
        if navigationBarView == nil {
            navigationBarView = NRInfoNavigationBarView(frame:CGRectMake(0, 0, self.view.frame.size.width, 175.0), title: self.info.domain, subTitle: self.info.availability?.capitalizedString, labelType: availabilityType, tld: result.tld)
        
            tableView.tableHeaderView = navigationBarView
            tableView.tableHeaderView!.layer.zPosition = 100
        }
        
        if result.availability != "unavailable" {
            tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - 50))
            
            let buttonFrame: CGRect = CGRectMake(0, self.view.frame.size.height - 50.0, self.view.frame.size.width, 50.0)
            actionButton = NRActionButton(frame: buttonFrame, buttonType: availabilityType)
            actionButton.addTarget(self, action: "presentAction", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(actionButton)
        }
        
        tableView.scrollEnabled = true
        tableView.reloadData()
    }
    
    func presentAction() {

        let registerURL: NSURL! = NSURL(string: info.register_url!)

        let registerViewController: SVWebViewController = SVWebViewController(URL: registerURL)
        registerViewController.title = info.registrars?.objectAtIndex(0).valueForKey("name") as? String

        self.navigationController?.pushViewController(registerViewController, animated: true)
        
    }
    
    func startFetchingInfo() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        infoManager.fetchInfoForDomain(result.domain)
        additionalInfoManager.fetchAdditionalInfoForDomain(result.domain, searchedString: result.searchedString)
    }
    
    // #pragma mark - NRInfoManagerDelegate
    
    func didReceiveInfo(info: NRInfo!) {
        self.info = info
    }
    
    func fetchingInfoFailedWithError(error: NSError!) {
        NSLog("Error Info %@; %@", error, error.localizedDescription)
        loadingFailed()
    }

    // #pragma mark - NRAdditionalInfoManagerDelegate
    
    func didReceiveAdditionalInfo(additionalInfo: NRAdditionalInfo!) {
        self.additionalInfo = additionalInfo

        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.reloadViews()
        });
    }
    
    func fetchingAdditionalInfoFailedWithError(error: NSError!) {
        NSLog("Error Additional Info %@; %@", error, error.localizedDescription)
        loadingFailed()
    }
    
    func loadingFailed() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.activityIndicatorView.hidden = true
        
        let alert = UIAlertController(title: "Oops!", message: "Sorry 'bout that, it looks like this page failed to load.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertActionStyle.Cancel, handler: { action in
            self.activityIndicatorView.hidden = true
            self.popViewController()
        }))
        
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { action in
            self.activityIndicatorView.hidden = false
            self.startFetchingInfo()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // #pragma mark - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var sectionTotal: Int = 1
        
        if info != nil {
            if info.registrars!.count > 0 {
                sectionTotal++
            }
        }
        
        if additionalInfo != nil {
            println(additionalInfo.domainAlternatives.count)
            if additionalInfo.domainAlternatives!.count > 0 {
                sectionTotal++;
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

            }
            
            if section == 1 && info.registrars!.count > 0 {
                
                if info.registrars!.count < 4 {
                    numberOfRows = info.registrars!.count
                } else {
                    numberOfRows = 4
                }
                
            } else if section == 1 && additionalInfo.domainAlternatives!.count > 0 {
                if additionalInfo.domainAlternatives!.count < 4 {
                    numberOfRows = additionalInfo.domainAlternatives!.count
                } else {
                    numberOfRows = 4
                }
            }
            
            if section == 2 && additionalInfo.domainAlternatives!.count > 0 {
                if additionalInfo.domainAlternatives!.count < 4 {
                    numberOfRows = additionalInfo.domainAlternatives!.count
                } else {
                    numberOfRows = 4
                }
            }
        }
        
        return numberOfRows
        
    }
    
    // #pragma mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 && info.registrars!.count > 0 {
            return createPurchaseHeader()
        } else if section == 1 && info.registrars!.count < 1 && additionalInfo.domainAlternatives!.count > 0 {
            return createAlternativesHeader()
        }
        
        if section == 2 && additionalInfo.domainAlternatives!.count > 0 {
            return createAlternativesHeader()
        }
        
        return UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 28.0))
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height: CGFloat = 25.0
        
        if section == 1 || section == 2 {
            height = 45.0
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {
            cell = createDefaultCell(indexPath)
        } else if indexPath.section == 1 && info.registrars!.count > 0 {
            cell = createRegistrarCell(indexPath)
        } else if indexPath.section == 1 && additionalInfo.domainAlternatives!.count > 0 {
            cell = createDomainCell(indexPath)
        } else if indexPath.section == 2 && additionalInfo.domainAlternatives!.count > 0 {
            cell = createDomainCell(indexPath)
        }
        
        cell.accessoryView = UIImageView(image: UIImage(named: "accessoryArrow")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        cell.accessoryView!.tintColor = NRColor().domainrAccessoryViewColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dispatch_async(dispatch_get_main_queue(), {
        
            var navController: UINavigationController! = UINavigationController()
            navController.navigationBar.barTintColor = UIColor.whiteColor()
            navController.navigationBar.tintColor = NRColor().domainrBlueColor()
            navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: NRColor().domainrRegularDarkGreyColor()]
            
            if indexPath.section == 0 {
                
                if indexPath.row == 0 {
                    
                    let whoisURL: NSURL! = NSURL(string: self.info.whois_url!)
                    let whoisViewController: SVWebViewController = SVWebViewController(URL: whoisURL)
                    whoisViewController.title = "Whois Info"

                    self.navigationController?.pushViewController(whoisViewController, animated: true)
                    
                } else if indexPath.row == 1 {
                    
                    let wikipediaURL: NSURL! = NSURL(string: self.info.tld!.valueForKey("wikipedia_url") as! String)
                    let wikipediaViewController: SVWebViewController = SVWebViewController(URL: wikipediaURL)
                    wikipediaViewController.title = "TLD Wikipedia Article"

                    self.navigationController?.pushViewController(wikipediaViewController, animated: true)
                
                }
            
            } else if indexPath.section == 1 && self.info.registrars!.count > 0 {
                
                if indexPath.row > 2 {
                    
                    let registrars: NSArray = self.info.registrars!.subarrayWithRange(NSMakeRange(3, self.info.registrars!.count-3))
                    let purchaseOptions: NSArray = self.additionalInfo.purchaseOptions
                    let registrarsViewController: NRRegistrarsViewController = NRRegistrarsViewController(registrars: registrars, purchaseOptions: purchaseOptions)

                    self.navigationController?.pushViewController(registrarsViewController, animated: true)
                
                } else {
                    
                    let registrarURL: NSURL! = NSURL(string: self.info.registrars!.objectAtIndex(indexPath.row).valueForKey("register_url") as! String)
                    let registrarViewController: SVWebViewController = SVWebViewController(URL: registrarURL)
                    registrarViewController.title = self.info.registrars!.objectAtIndex(indexPath.row).valueForKey("name") as? String

                    self.navigationController?.pushViewController(registrarViewController, animated: true)
                    
                }
            
            } else if indexPath.section == 1 && self.additionalInfo.domainAlternatives!.count > 0 {
                
                if indexPath.row > 2 {
                    
                    let newArray: NSArray = self.additionalInfo.domainAlternatives!.subarrayWithRange(NSMakeRange(3, self.additionalInfo.domainAlternatives!.count-3))
                    let registrarsViewController: NRAlternativeDomainsViewController = NRAlternativeDomainsViewController(alternatives: newArray, result: self.result)
                    
                    self.navigationController?.pushViewController(registrarsViewController, animated: true)
                    
                } else {
                    
                    let result: NRResult = self.result
                    
                    result.domain = self.additionalInfo.domainAlternatives.objectAtIndex(indexPath.row).objectForKey("text") as? String
                    var availabilityString: NSString = (self.additionalInfo.domainAlternatives!.objectAtIndex(indexPath.row).valueForKey("class") as? NSString)!
                    
                    if availabilityString.rangeOfString("available").location != NSNotFound {
                        result.availability = "available"
                    } else if availabilityString.rangeOfString("maybe").location != NSNotFound || availabilityString.rangeOfString("coming soon").location != NSNotFound {
                        result.availability = "Coming Soon"
                    } else if availabilityString.rangeOfString("taken").location != NSNotFound {
                        result.availability = "taken"
                    }
                    
                    let infoViewController: NRInfoViewController = NRInfoViewController(result: result)
                    
                    self.navigationController?.pushViewController(infoViewController, animated: true)
                    
                }
                
            } else if indexPath.section == 2 && self.additionalInfo.domainAlternatives!.count > 0 {
                
                if indexPath.row > 2 {
                    
                    let newArray: NSArray = self.additionalInfo.domainAlternatives!.subarrayWithRange(NSMakeRange(3, self.additionalInfo.domainAlternatives!.count-3))
                    let registrarsViewController: NRAlternativeDomainsViewController = NRAlternativeDomainsViewController(alternatives: newArray, result: self.result)
            
                    self.navigationController?.pushViewController(registrarsViewController, animated: true)
                    
                } else {
                    
                    let result: NRResult = self.result
                    
                    result.domain = self.additionalInfo.domainAlternatives.objectAtIndex(indexPath.row).objectForKey("text") as? String
                    var availabilityString: NSString = (self.additionalInfo.domainAlternatives!.objectAtIndex(indexPath.row).valueForKey("class") as? NSString)!
                    
                    if availabilityString.rangeOfString("available").location != NSNotFound {
                        result.availability = "available"
                    } else if availabilityString.rangeOfString("maybe").location != NSNotFound || availabilityString.rangeOfString("coming soon").location != NSNotFound {
                        result.availability = "Coming Soon"
                    } else if availabilityString.rangeOfString("taken").location != NSNotFound {
                        result.availability = "taken"
                    }
                
                    let infoViewController: NRInfoViewController = NRInfoViewController(result: result)
      
                    self.navigationController?.pushViewController(infoViewController, animated: true)
                    
                }
                
            }

        });
    }
    
    func createDefaultCell(indexPath: NSIndexPath!) -> NRInfoViewCell {
        
        var titleString: String! = "Whois Info"
        
        if indexPath.row == 1 {
           titleString = "TLD Wikipedia Article"
        }

        var cell: NRInfoViewCell? = tableView.dequeueReusableCellWithIdentifier("NRInfoViewCell", forIndexPath: indexPath) as? NRInfoViewCell
        
        if cell == nil {
            cell = NRInfoViewCell(title: titleString)
        } else {
            cell?.addViews(titleString)
        }

        return cell!
        
    }
    
    func createRegistrarCell(indexPath: NSIndexPath!) -> NRRegistrarCell {
        
        var cell: NRRegistrarCell! = tableView.dequeueReusableCellWithIdentifier("NRRegistrarCell", forIndexPath: indexPath) as? NRRegistrarCell
        
        if cell == nil {
            cell = NRRegistrarCell(style: .Default, reuseIdentifier: "NRRegistrarCell")
        } else {
            cell.addViews()
        }
        
        if indexPath.row <= 2 {
            var domainString: NSString = (info.registrars!.objectAtIndex(indexPath.row).valueForKey("name") as? String!)!
            var metaString: NSString?
            
            if indexPath.row < additionalInfo.purchaseOptions!.count-1 {

                metaString = (additionalInfo.purchaseOptions!.objectAtIndex(indexPath.row).valueForKey("text") as? NSString)!
                
                if metaString!.containsString("\n") {
                    metaString = (metaString!.componentsSeparatedByString("\n") as NSArray).objectAtIndex(1) as? NSString
                    
                    if metaString!.containsString("students") {
                        metaString = NSString(format: "Only %@", (metaString!.componentsSeparatedByString(" ") as NSArray).objectAtIndex(1) as! NSString)
                    }
                    
                    if metaString!.containsString(".co sale") {
                        metaString = ".co sale"
                    }
                } else {
                    metaString = nil
                }
            }
            
            cell.setTextLabels(domainString as String, subTitle: metaString as? String)
            cell.cellSubTitle.frame = CGRectMake(cell.frame.size.width - cell.cellSubTitle.frame.size.width - 30.0, cell.cellSubTitle.frame.origin.y, cell.cellSubTitle.frame.size.width, cell.cellSubTitle.frame.size.height)
            
        } else {
            cell.setTextLabel(NSString(format: "View %d Others", info.registrars!.count - 3) as String)
            cell.cellTitle.frame = CGRectMake(16.0, cell.cellTitle.frame.origin.y, cell.cellTitle.frame.size.width, cell.cellTitle.frame.size.height)
        }
        
        cell.cellTitle.frame = CGRectMake(15.0, 0, cell.cellTitle.frame.size.width, cell.cellTitle.frame.size.height)
        cell.cellTitle.center.y = round(cell.contentView.center.y)
        cell.cellTitle.frame = CGRectIntegral(cell.cellTitle.frame)
        
        return cell!
        
    }
    
    func createDomainCell(indexPath: NSIndexPath!) -> NRDomainCell {
        
        var cell: NRDomainCell! = tableView.dequeueReusableCellWithIdentifier("NRDomainCell", forIndexPath: indexPath) as? NRDomainCell
        
        if cell == nil {
            cell = NRDomainCell(style: .Default, reuseIdentifier: "NRDomainCell")
        } else {
            cell.addViews()
        }
        
        if indexPath.row <= 2 {

            var availabilityString: NSString = (additionalInfo.domainAlternatives!.objectAtIndex(indexPath.row).valueForKey("class") as? NSString)!
            println(availabilityString)
            cell.setAvailability(availabilityString as String)
            
            var domainString: NSString = (additionalInfo.domainAlternatives!.objectAtIndex(indexPath.row).valueForKey("text") as? NSString)!

            cell.setTextLabel(domainString as String)
        
        } else {
        
            cell.status.removeFromSuperview()
            cell.setTextLabel(NSString(format: "View %d Others", additionalInfo.domainAlternatives!.count - 3) as String)
            cell.cellTitle.frame = CGRectMake(16.0, cell.cellTitle.frame.origin.y, cell.cellTitle.frame.size.width, cell.cellTitle.frame.size.height)
            
        }
        
        return cell!
        
    }
    
    func createPurchaseHeader() -> UIView {
        
        let headerView: UIView! = UIView()
            headerView.frame = CGRectMake(0, 0, tableView.frame.size.width, 28.0)

        let headerImage: UIImageView! = UIImageView(image: UIImage(named: "shoppingCart")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
            headerImage.frame = CGRectMake(15.0, 24.0, 12.0, 11.0)
            headerImage.tintColor = NRColor().domainrSubtextGreyColor()
            headerImage.contentMode = UIViewContentMode.ScaleAspectFit
            headerView.addSubview(headerImage)
            headerImage.frame = CGRectIntegral(headerImage.frame)
        
        let headerTitle: UILabel! = UILabel()
            headerTitle.text = "PURCHASE OPTIONS"
            headerTitle.font = UIFont(name: "HelveticaNeue", size: 12.0)
            headerTitle.textColor = NRColor().domainrSubtextGreyColor()
            headerTitle.sizeToFit()
            headerTitle.frame = CGRectMake(33.0, 22.0, headerTitle.frame.size.width, headerTitle.frame.size.height)
            headerView.addSubview(headerTitle)
        
        let idnLabel: UILabel! = UILabel(frame: CGRectMake(tableView.frame.size.width - (27.0 + 15.0), 21.0, 27.0, 16.0))
            idnLabel.text = "IDN"
            idnLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 10.0)
            idnLabel.textColor = UIColor.whiteColor()
            idnLabel.backgroundColor = NRColor().domainrOrangeColor()
            idnLabel.textAlignment = NSTextAlignment.Center
            idnLabel.layer.cornerRadius = 2.0
            idnLabel.clipsToBounds = true
        
        let tldLabel: UILabel! = UILabel()
            tldLabel.text = (additionalInfo.domain != nil ? additionalInfo.domain.uppercaseString  : "")
            tldLabel.font = headerTitle.font
            tldLabel.textColor = headerTitle.textColor
            tldLabel.sizeToFit()
        
        if additionalInfo.isIDN == "IDN" {
            headerView.addSubview(idnLabel)
            tldLabel.frame = CGRectMake(idnLabel.frame.origin.x - (tldLabel.frame.size.width + 5.0), headerTitle.frame.origin.y, tldLabel.frame.size.width, headerTitle.frame.size.height)
        } else {
            tldLabel.frame = CGRectMake(self.view.frame.size.width - (tldLabel.frame.size.width + 15.0), headerTitle.frame.origin.y, tldLabel.frame.size.width, headerTitle.frame.size.height)
        }
        
            headerView.addSubview(tldLabel)
        
        return headerView
        
    }
    
    func createAlternativesHeader() -> UIView {
        
        let headerView: UIView! = UIView()
            headerView.frame = CGRectMake(0, 0, tableView.frame.size.width, 28.0)
        
        let headerImage: UIImageView! = UIImageView(image: UIImage(named: "alternativeDomains")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
            headerImage.frame = CGRectMake(15.0, 24.0, 12.0, 11.0)
            headerImage.tintColor = NRColor().domainrSubtextGreyColor()
            headerImage.contentMode = UIViewContentMode.ScaleAspectFit
            headerView.addSubview(headerImage)
            headerImage.frame = CGRectIntegral(headerImage.frame)
        
        let headerTitle: UILabel! = UILabel()
            headerTitle.text = "ALTERNATIVE DOMAINS"
            headerTitle.font = UIFont(name: "HelveticaNeue", size: 12.0)
            headerTitle.textColor = NRColor().domainrSubtextGreyColor()
            headerTitle.sizeToFit()
            headerTitle.frame = CGRectMake(33.0, 22.0, headerTitle.frame.size.width, headerTitle.frame.size.height)
            headerView.addSubview(headerTitle)
        
        return headerView
    }
    
    // #pragma mark - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        nr_resizeHeaderView(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        nr_resizeHeaderView(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        nr_resizeHeaderView(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        nr_resizeHeaderView(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        nr_resizeHeaderView(scrollView)
    }
    
    func reloadView() {
        self.activityIndicatorView.hidden = false
    }
    
    func popViewController() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.presentingViewController?.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func nr_resizeHeaderView(scrollView: UIScrollView) {
        
        if previousScrollOffsetY == nil {
            previousScrollOffsetY = scrollView.contentOffset.y
        }
        
        if scrollView.isEqual(tableView) {
            
            let velocity: CGFloat = scrollView.panGestureRecognizer.velocityInView(scrollView).y
            var offset: CGFloat! = scrollView.contentOffset.y

            if offset < 111.0 {
                
                if offset < 0 {
                    tableView.tableHeaderView!.frame.size.height = 175.0
                } else {
                    tableView.tableHeaderView!.frame.size.height += (previousScrollOffsetY - scrollView.contentOffset.y)
                }
                
                previousScrollOffsetY = offset
            } else {
                tableView.tableHeaderView!.frame.size.height = 64.0
                previousScrollOffsetY = 111.0
            }
            navigationBarView.centerElements()
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(tableView.tableHeaderView!.frame.size.height, 0, 0, 0)
        }
    }
    
    deinit {
        infoManager.communicator = nil
        additionalInfoManager.communicator = nil
        infoManager = nil
        additionalInfoManager = nil
    }
}
