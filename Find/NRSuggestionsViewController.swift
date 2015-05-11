//
//  NRSearchSuggestionsViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/14/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRSearchSuggestionsViewController: UIViewController, NRSearchSuggestionsManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    var activityIndicatorView: NRActivityIndicatorView!
    var tableView: UITableView!
    
    var query: String!
    var searchSuggestions: NSArray?
    var searchSuggestionManager: NRSearchSuggestionsManager!
    
    let searchSuggestionsTableViewCellIdentifier: String = "NRSearchSuggestionCell"
 
    init(query: String!){
        super.init(nibName: nil, bundle: nil)
        
        self.query = query
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
        self.title = "Search Suggestions"
        
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
   
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NRSearchSuggestionCell.self, forCellReuseIdentifier: searchSuggestionsTableViewCellIdentifier)
        tableView.backgroundColor = NRColor().domainrBackgroundGreyColor()
        tableView.separatorColor = NRColor().domairTableViewSeparatorBorder()
        tableView.contentInset = UIEdgeInsetsMake(36.0, 0, 0.0, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0)
        tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        tableView.tableHeaderView?.backgroundColor = NRColor().domairTableViewSeparatorBorder()
        tableView.tableFooterView?.backgroundColor = NRColor().domairTableViewSeparatorBorder()
        self.view.addSubview(tableView)
        
        self.activityIndicatorView = NRActivityIndicatorView(image: UIImage(named: "activityIndicator")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        self.activityIndicatorView.center = CGPointIntegral(self.view.center)
        self.activityIndicatorView.tintColor = NRColor().domainrBlueColor()
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()
        
        searchSuggestionManager = NRSearchSuggestionsManager()
        searchSuggestionManager.communicator = NRSearchSuggestionsCommunicator()
        searchSuggestionManager.communicator.delegate = searchSuggestionManager
        searchSuggestionManager.delegate = self
        
        startFetchingSearchSuggestionForQuery(query)
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
    
    func startFetchingSearchSuggestionForQuery(queryString: String!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        searchSuggestionManager.fetchSearchSuggestionsForDomain(queryString)
    }
    
    func popViewController() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // #pragma mark - NRSearchSuggestinosManagerDelegate
    
    func didReceiveSearchSuggestions(suggestions: NSArray!) {
        self.searchSuggestions = suggestions
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.activityIndicatorView.removeFromSuperview()
            self.tableView.reloadData()
        });
    }
    
    func fetchingSearchSuggestionsFailedWithError(error: NSError!) {
        NSLog("Error Suggestions %@; %@", error, error.localizedDescription)
        loadingFailed()
    }
    
    func loadingFailed() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.activityIndicatorView.hidden = true
        
        let alert = UIAlertController(title: "Oops!", message: "Sorry 'bout that, it looks like this page failed to load.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertActionStyle.Destructive, handler: { action in
            self.popViewController()
        }))
        
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { action in
            self.activityIndicatorView.hidden = false
            self.startFetchingSearchSuggestionForQuery(self.query)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // #pragma mark - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchSuggestions != nil {
            self.tableView.separatorStyle = .SingleLine
            return self.searchSuggestions!.count-1
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
        
        var cell: NRSearchSuggestionCell! = tableView.dequeueReusableCellWithIdentifier(searchSuggestionsTableViewCellIdentifier) as! NRSearchSuggestionCell
        
        if cell == nil {
            cell = NRSearchSuggestionCell(style: .Default, reuseIdentifier: searchSuggestionsTableViewCellIdentifier)
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = self.searchSuggestions?.objectAtIndex(indexPath.row) as? String
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    deinit {
        searchSuggestionManager.communicator = nil
        searchSuggestionManager = nil
    }
    
}
