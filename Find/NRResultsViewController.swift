//
//  NRResultsViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRResultsViewController: UITableViewController, NRResultsManagerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    var results: NSArray?
    var manager: NRResultsManager!
    
    var resultsSearchBar: UISearchBar!
    var resultsSearchController: UISearchController!
    let resultsTableViewCellIdentifier: String = "NRResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        self.view.backgroundColor = UIColor.whiteColor()
        
        manager = NRResultsManager()
        manager.communicator = NRResultsCommunicator()
        manager.communicator.delegate = manager
        manager.delegate = self

        resultsSearchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        
        resultsSearchController = UISearchController(searchResultsController: nil)
        resultsSearchController.searchResultsUpdater = self
        resultsSearchController.searchBar.searchBarStyle = .Minimal
        resultsSearchController.searchBar.sizeToFit()
        resultsSearchController.searchBar.delegate = self
        resultsSearchController.searchBar.backgroundColor = UIColor.whiteColor()
        resultsSearchController.searchBar.setShowsCancelButton(false, animated: false)
        resultsSearchController.definesPresentationContext = true
        resultsSearchController.hidesNavigationBarDuringPresentation = false
        resultsSearchController.dimsBackgroundDuringPresentation = false

        self.tableView.registerClass(NRResultCell.self, forCellReuseIdentifier: resultsTableViewCellIdentifier)
        self.tableView.tableHeaderView = resultsSearchController.searchBar
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFetchingResultsFromQuery(query: String!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        manager.fetchResultsForQuery(query)
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
        if results != nil {
            return self.results!.count-1
        } else {
            return 0
        }
    }
    
    // #pragma mark - UITableViewDataSooverride urce
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: NRResultCell! = tableView.dequeueReusableCellWithIdentifier(resultsTableViewCellIdentifier, forIndexPath: indexPath) as NRResultCell
            
        if cell == nil {
            cell = NRResultCell() as NRResultCell
        }

        cell.textLabel?.text = results!.objectAtIndex(indexPath.row).domain
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        resultsSearchController.active = false
        
        let result: NRResult = results!.objectAtIndex(indexPath.row) as NRResult
        let infoViewController: NRInfoViewController = NRInfoViewController()
        infoViewController.initWithDomainResult(result)
        
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
    
    // #pragma mark - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        resultsSearchController.searchBar.setShowsCancelButton(false, animated: false)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.returnKeyType = .Done
        return true
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        resultsSearchController.searchBar.setShowsCancelButton(false, animated: false)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        resultsSearchController.searchBar.setShowsCancelButton(false, animated: false)
    }
    
    // #pragma mark - UISearchResultsUpdating Protocol
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        startFetchingResultsFromQuery(searchController.searchBar.text)
    }
    
}

