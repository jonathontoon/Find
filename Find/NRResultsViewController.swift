//
//  NRResultsViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/1/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRResultsViewController: UIViewController, NRResultsManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    var results: NSArray?
    var manager: NRResultsManager!
    
    var resultsTableView: UITableView!
    let resultsTableViewCellIdentifier: String = "NRResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        self.view.backgroundColor = UIColor.whiteColor()
        
        manager = NRResultsManager()
        manager.communicator = NRResultsCommunicator()
        manager.communicator.delegate = manager
        manager.delegate = self

        startFetchingResults()
        
        resultsTableView = UITableView(frame: self.view.frame)
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.registerClass(NRResultCell.self, forCellReuseIdentifier: resultsTableViewCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFetchingResults() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        manager.fetchResultsForQuery("keepitreal.com")
    }
    
    // #pragma mark - NRResultsManagerDelegate
    
    func didReceiveResults(results: NSArray!) {
        self.results = results
        
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.view.addSubview(self.resultsTableView)
            self.resultsTableView.reloadData()
        });
    }
    
    func fetchingResultsFailedWithError(error: NSError!) {
        NSLog("Error %@; %@", error, error.localizedDescription)
    }
    
    // #pragma mark - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results != nil {
            return self.results!.count-1
        } else {
            return 0
        }
    }
    
    // #pragma mark - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: NRResultCell! = tableView.dequeueReusableCellWithIdentifier(resultsTableViewCellIdentifier, forIndexPath: indexPath) as NRResultCell
        
        if cell == nil {
            cell = NRResultCell() as NRResultCell
        }

        cell.textLabel?.text = results!.objectAtIndex(indexPath.row).domain
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let result: NRResult = results!.objectAtIndex(indexPath.row) as NRResult
        let infoViewController: NRInfoViewController = NRInfoViewController()
        infoViewController.initWithDomainResult(result)
        
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
    
}

