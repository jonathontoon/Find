//
//  NRAlternativeDomainsViewController.swift
//  Find
//
//  Created by Jonathon Toon on 5/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRAlternativeDomainsViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    var initialResult: NRResult!
    var alternatives: NSArray!
    var tableView: UITableView!
    
    let registrarsTableViewCellIdentifier: String = "NRAlternativeDomainCell"
    
    init(alternatives: NSArray!, result:NRResult!) {
        super.init(nibName: nil, bundle: nil)
        
        self.initialResult = result
        self.alternatives = alternatives
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
        
        self.title = "Alternative Domains"
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NRDomainCell.self, forCellReuseIdentifier: registrarsTableViewCellIdentifier)
        tableView.backgroundColor = NRColor().domainrBackgroundGreyColor()
        tableView.separatorColor = NRColor().domairTableViewSeparatorBorder()
        tableView.contentInset = UIEdgeInsetsMake(36.0, 0, 0.0, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0)
        tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        tableView.tableHeaderView?.backgroundColor = NRColor().domairTableViewSeparatorBorder()
        tableView.tableFooterView?.backgroundColor = NRColor().domairTableViewSeparatorBorder()
        self.view.addSubview(tableView)
        
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
        
        if alternatives != nil {
            self.tableView.separatorStyle = .SingleLine
            return alternatives!.count
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
        
        var cell: NRDomainCell! = tableView.dequeueReusableCellWithIdentifier(self.registrarsTableViewCellIdentifier) as? NRDomainCell
        
        if cell == nil {
            cell = NRDomainCell(style: .Default, reuseIdentifier: self.registrarsTableViewCellIdentifier)
        } else {
            cell.addViews()
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        var availabilityString: NSString = (self.alternatives.objectAtIndex(indexPath.row).valueForKey("class") as? NSString)!
        println(availabilityString)
        cell.setAvailability(availabilityString as String)
        
        var domainString: NSString = (self.alternatives.objectAtIndex(indexPath.row).valueForKey("text") as? NSString)!
        println(domainString)
        cell.setTextLabel(domainString as String)

        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let result: NRResult = self.initialResult
        
        result.domain = alternatives.objectAtIndex(indexPath.row).objectForKey("text") as? String
        var availabilityString: NSString = (alternatives.objectAtIndex(indexPath.row).valueForKey("class") as? NSString)!
        
        println("@@@@@@@@")
        println(result.domain)
        println(availabilityString)
        
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
