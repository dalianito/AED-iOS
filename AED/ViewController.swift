//
//  ViewController.swift
//  AED
//
//  Created by Yang Yu on 10/6/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    // Mark: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var floorPlanImage: UIImageView!
    
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var specificLocationLabel: UILabel!
    @IBOutlet weak var directionToFindLabel: UILabel!
    
    var aed : AEDModel!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildingNameLabel.text = aed.building.name
        floorLabel.text = aed.floor
        specificLocationLabel.text = aed.specificLocation
        directionToFindLabel.text = aed.directionToFind
        
        directionToFindLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        directionToFindLabel.frame.size.width = 50
        print(directionToFindLabel.frame)

        let height = previewImage.frame.origin.y + 320
        print(height)
        scrollView.contentSize.height = height
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Navigations
    @IBAction func backToResultView(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }
}

