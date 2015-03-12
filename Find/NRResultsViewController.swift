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
    
    var resultsSearchController: UISearchController!
    let suggestionsTableViewCellIdentifier: String = "NRSuggestionCell"
    let resultsTableViewCellIdentifier: String = "NRResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.view.backgroundColor = UIColor.whiteColor()
        
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
        
        // Hack to change the UISearchBar style
        (resultsSearchController.searchBar.subviews[0].subviews[1] as UITextField).borderStyle = .None

        
        resultsSearchController.definesPresentationContext = true
        resultsSearchController.hidesNavigationBarDuringPresentation = false
        resultsSearchController.dimsBackgroundDuringPresentation = false

        self.tableView.registerClass(NRResultCell.self, forCellReuseIdentifier: resultsTableViewCellIdentifier)
        self.tableView.registerClass(NRSuggestionCell.self, forCellReuseIdentifier: suggestionsTableViewCellIdentifier)
        self.navigationItem.titleView = resultsSearchController.searchBar
       
        // Implement API stuff
        // https://www.kimonolabs.com/api/ondemand/9c160p7k?apikey=e64b763681f140bec8391a4e8547d9dd&kimmodify=1&keyword=KEYWORD
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
        
        if results != nil {
            return self.results!.count-1
        } else {
            return 0
        }
        
    }
    
    // #pragma mark - UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> NRResultCell {
        
        var cell: NRResultCell! = tableView.dequeueReusableCellWithIdentifier(resultsTableViewCellIdentifier) as NRResultCell
        
        if cell == nil {
            cell = NRResultCell(style: .Default, reuseIdentifier: resultsTableViewCellIdentifier)
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = (results!.objectAtIndex(indexPath.row) as NRResult).domain! + " " + (results!.objectAtIndex(indexPath.row) as NRResult).availability!
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isSearching == true {
            resultsSearchController.active = false
            
            let result: NRResult = results!.objectAtIndex(indexPath.row) as NRResult
            let infoViewController: NRInfoViewController = NRInfoViewController(result: result)
           
            self.navigationController?.pushViewController(infoViewController, animated: true)
        
        }
    }
    
    // #pragma mark - UISearchBarDelegate
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        NSLog("searchBarSearchButtonClicked")
        isSearching = true
        startFetchingResultsFromQuery(resultsSearchController.searchBar.text)
    }
    
    // #pragma mark - UIS earchResultsUpdating Protocol
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        NSLog("updateSearchResultsForSearchController")
    }
    
    // #pragma mark - UIScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
}

