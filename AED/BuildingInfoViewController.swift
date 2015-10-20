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
        
        addGestureRecognation()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        buildingAddressLabel.text = building.address
        buildingPhoneLabel.text = building.phone
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = building.name
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
    
    // MARK: - Action
    @IBAction func backToMapView(sender: UIBarButtonItem) {
        closeCurrentView()
    }
    
    
    // MARK: - Gesture and Navigation
    
    func addGestureRecognation() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                closeCurrentView()
            default:
                break
            }
        }
    }
    
    func closeCurrentView() {
        navigationController!.setNavigationBarHidden(true, animated: false)
        navigationController!.popViewControllerAnimated(true)
    }
}
