//
//  ViewController.swift
//  AED
//
//  Created by Yang Yu on 10/6/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Mark: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var floorPlanImage: UIImageView!
    
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var specificLocationLabel: UILabel!
    @IBOutlet weak var directionToFindLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildingNameLabel.text = "万达广场"
        floorLabel.text = "2F"
        specificLocationLabel.text = "2楼扶梯左边"
        directionToFindLabel.text = "detailed direction to find the AED"

        directionToFindLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        directionToFindLabel.frame.size.width = 50
        print(directionToFindLabel.frame)
        // Do any additional setup after loading the view, typically from a nib.
        print(previewImage.frame)
        print(previewImage)
        print(previewImage.bounds)
        print(floorPlanImage.frame)
        
        let height = previewImage.frame.origin.y + 320
        print(height)
        scrollView.contentSize.height = height
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

