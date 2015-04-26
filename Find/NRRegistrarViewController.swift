//
//  NRRegistrarViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/15/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRRegistrarViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    var registrars: NSArray!
    var tableView: UITableView!
    
    let registrarsTableViewCellIdentifier: String = "NRInfoViewRegistrarCell"
    
    init(registrars: NSArray!) {
        super.init(nibName: nil, bundle: nil)
        
        self.registrars = registrars
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        styleNavigationBar()
        self.navigationController!.interactivePopGestureRecognizer.delegate = self
    }
    
    override func viewDidLoad() {
        
        self.title = "More Registrars"
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NRInfoViewRegistrarCell.self, forCellReuseIdentifier: registrarsTableViewCellIdentifier)
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
        
        if registrars != nil {
            self.tableView.separatorStyle = .SingleLine
            return registrars!.count-1
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
        
        var cell: NRInfoViewRegistrarCell! = tableView.dequeueReusableCellWithIdentifier("NRInfoViewRegistrarCell", forIndexPath: indexPath) as? NRInfoViewRegistrarCell
        
        if cell == nil {
            cell = NRInfoViewRegistrarCell(style: .Default, reuseIdentifier: registrarsTableViewCellIdentifier)
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell?.textLabel?.text = registrars!.objectAtIndex(indexPath.row).valueForKey("name") as? String
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var navController: UINavigationController! = UINavigationController()
        navController.navigationBar.barTintColor = UIColor.whiteColor()
        navController.navigationBar.tintColor = NRColor().domainrBlueColor()
        navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: NRColor().domainrRegularDarkGreyColor()]
        
        let registrarURL: NSURL! = NSURL(string: registrars!.objectAtIndex(indexPath.row).valueForKey("register_url") as! String)
        let registrarViewController: SVWebViewController = SVWebViewController(URL: registrarURL)
        registrarViewController.title = registrars!.objectAtIndex(indexPath.row).valueForKey("name") as? String
        
        navController!.viewControllers = [registrarViewController]
        self.presentViewController(navController, animated: true, completion: nil)
        
    }

}
