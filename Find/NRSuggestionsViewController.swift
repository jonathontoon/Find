//
//  NRSearchSuggestionsViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/14/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRSearchSuggestionsViewController: UIViewController, NRSearchSuggestionsManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

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
        var selection: NSIndexPath? = self.tableView?.indexPathForSelectedRow()
        if (selection != nil) {
            self.tableView.deselectRowAtIndexPath(selection!, animated:true)
        }
    }
    
    override func viewDidLoad() {
        self.title = "Search Suggestions"
        
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        self.navigationController!.interactivePopGestureRecognizer.delegate = self
        
        let backButtonItem: UIBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
        
        self.title = "Search Suggestions"
        
        self.navigationItem.titleView?.backgroundColor = UIColor.clearColor()
        self.navigationItem.titleView?.layer.backgroundColor = UIColor.clearColor().CGColor
        
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NRSearchSuggestionCell.self, forCellReuseIdentifier: searchSuggestionsTableViewCellIdentifier)
        tableView.backgroundColor = NRColor().domainrBackgroundGreyColor()
        tableView.separatorColor = NRColor().domairTableViewSeparatorBorder()
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0)
        tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        tableView.tableHeaderView?.backgroundColor = NRColor().domairTableViewSeparatorBorder()
        tableView.tableFooterView?.backgroundColor = NRColor().domairTableViewSeparatorBorder()
        self.view.addSubview(tableView)
        
        searchSuggestionManager = NRSearchSuggestionsManager()
        searchSuggestionManager.communicator = NRSearchSuggestionsCommunicator()
        searchSuggestionManager.communicator.delegate = searchSuggestionManager
        searchSuggestionManager.delegate = self
        
        startFetchingSearchSuggestionForQuery(query)
    }

    func startFetchingSearchSuggestionForQuery(queryString: String!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        searchSuggestionManager.fetchSearchSuggestionsForDomain(queryString)
    }
    
    func popViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // #pragma mark - NRSearchSuggestinosManagerDelegate
    
    func didReceiveSearchSuggestions(suggestions: NSArray!) {
        self.searchSuggestions = suggestions

        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.tableView.reloadData()
            println(self.searchSuggestions)
        });
    }
    
    func fetchingSearchSuggestionsFailedWithError(error: NSError!) {
        NSLog("Error %@; %@", error, error.localizedDescription)
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
    
}
