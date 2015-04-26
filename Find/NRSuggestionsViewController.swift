//
//  NRSearchSuggestionsViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/14/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRSearchSuggestionsViewController: UITableViewController, NRSearchSuggestionsManagerDelegate {

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
    
    override func viewDidLoad() {
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        
        let backButtonItem: UIBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
        
        self.title = "Search Suggestions"
        
        self.navigationItem.titleView?.backgroundColor = UIColor.clearColor()
        self.navigationItem.titleView?.layer.backgroundColor = UIColor.clearColor().CGColor
        
        searchSuggestionManager = NRSearchSuggestionsManager()
        searchSuggestionManager.communicator = NRSearchSuggestionsCommunicator()
        searchSuggestionManager.communicator.delegate = searchSuggestionManager
        searchSuggestionManager.delegate = self
        
        self.tableView.registerClass(NRSearchSuggestionCell.self, forCellReuseIdentifier: searchSuggestionsTableViewCellIdentifier)
        self.tableView.contentInset = UIEdgeInsetsMake(36.0, 0, 0, 0)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        startFetchingSearchSuggestionForQuery(query)
    }
    
    func startFetchingSearchSuggestionForQuery(queryString: String!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        searchSuggestionManager.fetchSearchSuggestionsForDomain(queryString)
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchSuggestions != nil {
            self.tableView.separatorStyle = .SingleLine
            return self.searchSuggestions!.count-1
        } else {
            self.tableView.separatorStyle = .None
            return 0
        }
    }
    
    // #pragma mark - UITableViewDelegate

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: NRSearchSuggestionCell! = tableView.dequeueReusableCellWithIdentifier(searchSuggestionsTableViewCellIdentifier) as! NRSearchSuggestionCell
        
        if cell == nil {
            cell = NRSearchSuggestionCell(style: .Default, reuseIdentifier: searchSuggestionsTableViewCellIdentifier)
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = self.searchSuggestions?.objectAtIndex(indexPath.row) as? String
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
