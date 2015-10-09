//
//  AEDTableViewController.swift
//  AED
//
//  Created by Yang Yu on 10/8/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit
import CoreData

class AEDTableViewController: UITableViewController {
    
    // Mark: Properties
    var availableBuildings = [BuildingModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
    

        let request = NSFetchRequest()
        availableBuildings = BuildingDAO.sharedDAO.selectByFetchRequest(request)

    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source for section

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return availableBuildings.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return availableBuildings[section].name
    }
    
    // MARK: - Table view data source for cell
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableBuildings[section].getAEDs().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AEDInfoCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AEDInfoTableViewCell
        cell.aed = availableBuildings[indexPath.section].getAED(indexPath.row)
        cell.setView()
        
        return cell
    }



    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ShowDetail" {
            let aedDetailViewController = segue.destinationViewController as! ViewController
            let selectedAEDInfoCell = sender as! AEDInfoTableViewCell
            
            aedDetailViewController.aed = selectedAEDInfoCell.aed
        }
    }

}
