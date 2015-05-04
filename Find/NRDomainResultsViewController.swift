//
//  NRResultsViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRResultsViewController: UITableViewController, NRResultsManagerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate {
    
    var results: NSArray?
    var resultsManager: NRResultsManager!
    
    var isSearching: Bool! = false
    
    var query: String!
    
    var resultsSearchController: UISearchController!
    let resultsTableViewCellIdentifier: String = "NRDomainCell"
    let suggestionOptionCellIdentifier: String = "NRSuggestionOptionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        
        resultsManager = NRResultsManager()
        resultsManager.communicator = NRResultsCommunicator()
        resultsManager.communicator.delegate = resultsManager
        resultsManager.delegate = self

        resultsSearchController = UISearchController(searchResultsController: nil)
        resultsSearchController.searchResultsUpdater = self
        
        resultsSearchController.searchBar.searchBarStyle = .Prominent
        resultsSearchController.searchBar.sizeToFit()
        resultsSearchController.searchBar.delegate = self
        resultsSearchController.searchBar.backgroundColor = UIColor.clearColor()
        resultsSearchController.searchBar.setShowsCancelButton(false, animated: false)
        
        if self.query != nil {
            resultsSearchController.searchBar.placeholder = self.query
            resultsSearchController.searchBar.text = self.query
        } else {
            resultsSearchController.searchBar.placeholder = "Search for a name or URL..."
        }
        
        // Rough code to change the UISearchBar style
        (resultsSearchController.searchBar.subviews[0].subviews[1] as! UITextField).borderStyle = .None
        
        resultsSearchController.definesPresentationContext = true
        resultsSearchController.hidesNavigationBarDuringPresentation = false
        resultsSearchController.dimsBackgroundDuringPresentation = false

        self.tableView.registerClass(NRDomainCell.self, forCellReuseIdentifier: resultsTableViewCellIdentifier)
        self.tableView.registerClass(NRDefaultCell.self, forCellReuseIdentifier: suggestionOptionCellIdentifier)
        self.tableView.backgroundColor = NRColor().domainrBackgroundGreyColor()
        self.tableView.separatorColor = NRColor().domairTableViewSeparatorBorder()
        self.tableView.contentInset = UIEdgeInsetsMake(25.0, 0, 0.0, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0)
        self.navigationItem.titleView = resultsSearchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFetchingResultsFromQuery(query: String!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        resultsManager.fetchResultsForQuery(query)
    }

    // #pragma mark - NRResultsManagerDelegate
    
    func didReceiveResults(results: NSArray!) {
        self.results = results
        
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            self.tableView.reloadData()
        });
    }
    
    func fetchingResultsFailedWithError(error: NSError!) {
        NSLog("Error %@; %@", error, error.localizedDescription)
    }
    
    // #pragma mark - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int!
        self.tableView.separatorStyle = .SingleLine
        
        if isSearching == true && resultsSearchController.searchBar.text != nil {
            
            numberOfRows = 1
            
        } else {

            if results != nil {
                
                numberOfRows = self.results!.count-1
                
            } else {
                
                self.tableView.separatorStyle = .None
                numberOfRows = 0
                
            }
            
        }
        
        return numberOfRows
    }
    
    // #pragma mark - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if isSearching == false {
            
            if self.results?.count > 0 {
                
                cell = tableView.dequeueReusableCellWithIdentifier(resultsTableViewCellIdentifier) as! NRDomainCell
            
                if cell == nil {
                    cell = NRDomainCell(style: .Default, reuseIdentifier: resultsTableViewCellIdentifier)
                } else {
                    (cell as! NRDomainCell).addViews()
                }
                
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.textLabel?.text = (results!.objectAtIndex(indexPath.row) as! NRResult).domain! + " " + (results!.objectAtIndex(indexPath.row) as! NRResult).availability!
            }
        
        } else if isSearching == true && resultsSearchController.searchBar.text != nil {
            
            cell = tableView.dequeueReusableCellWithIdentifier(suggestionOptionCellIdentifier) as! NRDefaultCell
            
            if cell == nil {
                cell = NRDefaultCell(style: .Default, reuseIdentifier: suggestionOptionCellIdentifier)
            }
            
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.text = "Suggestions for \"" + resultsSearchController.searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "") + "\""
            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var viewControllerForPush: UIViewController!
        
        if isSearching == false && self.results?.count > 0 {
            
            let result: NRResult = results!.objectAtIndex(indexPath.row) as! NRResult
            result.searchedString = resultsSearchController.searchBar.text
            
            result.tld = (split(result.domain!, maxSplit: 1, allowEmptySlices: false, isSeparator: { $0 == "."}) as NSArray).objectAtIndex(1) as? String
            if result.availability == "maybe" {
                result.availability = "Coming Soon"
            }
            
            viewControllerForPush = NRInfoViewController(result: result)
           
        } else if isSearching == true {
            
            if indexPath.row == 0 {
                viewControllerForPush = NRSearchSuggestionsViewController(query: resultsSearchController.searchBar.text)
            } else {
                // Search Using History
            }
        }
        
        self.resultsSearchController.active = false
        
        if viewControllerForPush.isKindOfClass(NRInfoViewController) {
            
            var navigationController: UINavigationController = UINavigationController(rootViewController: viewControllerForPush)
            navigationController.navigationBar.barStyle = UIBarStyle.Black
            self.presentViewController(navigationController, animated: true, completion: nil)
            
        } else {
            self.navigationController?.pushViewController(viewControllerForPush, animated: true)
        }
    }
    
    // #pragma mark - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        isSearching = false
        self.query = searchBar.text
        startFetchingResultsFromQuery(self.query)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isSearching = false
        self.tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        isSearching = true
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0.5))
        self.tableView.tableHeaderView?.backgroundColor = NRColor().domairTableViewSeparatorBorder()
        self.tableView.tableFooterView =  UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0.5))
        self.tableView.tableFooterView?.backgroundColor = NRColor().domairTableViewSeparatorBorder()
        self.tableView.reloadData()
    }
    
    // #pragma mark - UISearchResultsUpdating Protocol
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        NSLog("updateSearchResultsForSearchController")
        
        if searchController.searchBar.text != nil {
            self.query = searchController.searchBar.text
        }
    }
    
    // #pragma mark - UIScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}

