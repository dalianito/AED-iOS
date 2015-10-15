//
//  BuildingInfoViewController.swift
//  AED
//
//  Created by Yang Yu on 10/15/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class BuildingInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var building: BuildingModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buildingAddressLabel: UILabel!
    @IBOutlet weak var buildingPhoneLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        buildingAddressLabel.text = building.address
        buildingPhoneLabel.text = building.phone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(building.getAEDs().count)
        return building.getAEDs().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AEDInfoCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AEDTableViewCell
        cell.aed = building.getAED(indexPath.row)
        cell.setView()
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backToMapView(sender: UIBarButtonItem) {
         navigationController!.popViewControllerAnimated(true)
    }
}
