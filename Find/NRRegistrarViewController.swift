//
//  NRRegistrarViewController.swift
//  Find
//
//  Created by Jonathon Toon on 3/15/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

class NRRegistrarViewController: UITableViewController {

    var registrars: NSArray!
    
    let registrarsTableViewCellIdentifier: String = "NRInfoViewRegistrarCell"
    
    init(registrars: NSArray!) {
        super.init(nibName: nil, bundle: nil)
        
        self.registrars = registrars
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.title = "More Registrars"
        self.view.backgroundColor = NRColor().domainrBackgroundGreyColor()
        
        let backButtonItem: UIBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
        
        self.tableView.registerClass(NRInfoViewRegistrarCell.self, forCellReuseIdentifier: registrarsTableViewCellIdentifier)
        self.tableView.contentInset = UIEdgeInsetsMake(36.0, 0, 36.0, 0)
    }
    
    // #pragma mark - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if registrars != nil {
            self.tableView.separatorStyle = .SingleLine
            return registrars!.count-1
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
        
        var cell: NRInfoViewRegistrarCell! = tableView.dequeueReusableCellWithIdentifier("NRInfoViewRegistrarCell", forIndexPath: indexPath) as? NRInfoViewRegistrarCell
        
        if cell == nil {
            cell = NRInfoViewRegistrarCell(style: .Default, reuseIdentifier: registrarsTableViewCellIdentifier)
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell?.textLabel?.text = registrars!.objectAtIndex(indexPath.row).valueForKey("name") as NSString
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
