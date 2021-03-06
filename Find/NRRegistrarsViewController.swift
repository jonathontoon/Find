//
//  NRRegistrarsViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/15/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRRegistrarsViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    var registrars: NSArray!
    var purchaseOptions: NSArray!
    
    var tableView: UITableView!
    
    let registrarsTableViewCellIdentifier: String = "NRRegistrarsCell"
    
    init(registrars: NSArray!, purchaseOptions: NSArray?) {
        super.init(nibName: nil, bundle: nil)
        
        self.registrars = registrars
        self.purchaseOptions = purchaseOptions
        
        println(self.purchaseOptions)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        styleNavigationBar()
        self.navigationController!.interactivePopGestureRecognizer.delegate = self
        
        var selection: NSIndexPath? = self.tableView?.indexPathForSelectedRow()
        if (selection != nil) {
            self.tableView.deselectRowAtIndexPath(selection!, animated:true)
        }
    }
    
    override func viewDidLoad() {
        
        self.title = "More Registrars"
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        
    }
    
    func styleNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let newNavigationBar: UINavigationBar! = UINavigationBar(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0))
        newNavigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
        newNavigationBar.translucent = true
        newNavigationBar.tintColor = NRColor().domainrBlueColor()
        newNavigationBar.titleTextAttributes = [NSForegroundColorAttributeName: NRColor().domainrRegularDarkGreyColor()]
        
        let titleItem = UINavigationItem()
        titleItem.title = self.title
        
        let backButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButton")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), style: UIBarButtonItemStyle.Plain, target: self, action: "popViewController")
        titleItem.leftBarButtonItem = backButtonItem
        
        newNavigationBar.setItems([titleItem], animated: false)
        self.view.addSubview(newNavigationBar)
    }
    
    func popViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // #pragma mark - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if registrars != nil {
            self.tableView.separatorStyle = .SingleLine
            return registrars!.count
        } else {
            self.tableView.separatorStyle = .None
            return 0
        }
    }
    
    // #pragma mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: NRRegistrarCell! = tableView.dequeueReusableCellWithIdentifier(registrarsTableViewCellIdentifier) as? NRRegistrarCell
        
        if cell == nil {
            cell = NRRegistrarCell(style: .Default, reuseIdentifier: registrarsTableViewCellIdentifier)
        } else {
            cell.addViews()
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        var domainString: NSString = (self.registrars!.objectAtIndex(indexPath.row).valueForKey("name") as? String!)!
        var metaString: NSString?
   
        for option in self.purchaseOptions {
            
            if (option.valueForKey("text") as! NSString).containsString(domainString as! String) {
             
                if (option.valueForKey("text") as! NSString).containsString("\n") {
                    metaString = ((option.valueForKey("text") as! NSString).componentsSeparatedByString("\n") as NSArray).objectAtIndex(1) as? NSString
                    
                    println(metaString)
                    
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
        }
        
        cell.setTextLabels(domainString as String, subTitle: metaString as? String)
        cell.cellSubTitle.frame = CGRectMake(cell.frame.size.width - cell.cellSubTitle.frame.size.width - 30.0, cell.cellSubTitle.frame.origin.y, cell.cellSubTitle.frame.size.width, cell.cellSubTitle.frame.size.height)
        
        cell.cellTitle.frame = CGRectMake(15.0, 0, cell.cellTitle.frame.size.width, cell.cellTitle.frame.size.height)
        cell.cellTitle.center.y = round(cell.contentView.center.y)
        cell.cellTitle.frame = CGRectIntegral(cell.cellTitle.frame)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let registrarURL: NSURL! = NSURL(string: registrars!.objectAtIndex(indexPath.row).valueForKey("register_url") as! String)
        let registrarViewController: SVWebViewController = SVWebViewController(URL: registrarURL)
        registrarViewController.title = registrars!.objectAtIndex(indexPath.row).valueForKey("name") as? String
        
        self.navigationController?.pushViewController(registrarViewController, animated: true)
    }

}
