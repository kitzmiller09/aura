//
//  MenuTableViewController.swift
//  SlideMenu
//
//  Created by Simon Ng on 9/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var menuItems = ["Current Location", "Manassas, VA", "Lyncburg, VA", "San Francisco, CA", "Hershey, PA"]
    var currentItem = "Aura"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menuItems.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MenuTableViewCell
        
        // Configure the cell...
        if indexPath.row != menuItems.count{
            cell.titleLabel.text = menuItems[indexPath.row]
        }else {
            cell.titleLabel.text = "+ Add Another City..."
            cell.titleLabel.textColor =  UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let menuTableViewController = segue.sourceViewController as! MenuTableViewController
        let selectedRow = menuTableViewController.tableView.indexPathForSelectedRow!.row
        currentItem = menuItems[selectedRow]
    }

}
