//
//  HospitalInfoViewController.swift
//  AED
//
//  Created by Yang Yu on 10/22/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class HospitalInfoViewController: UIViewController {
    var hospital: HospitalModel?

    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        hospitalNameLabel.text = hospital!.name
        addressLabel.text = "地址: \(hospital!.address)"
        phoneLabel.text = "电话: \(hospital!.phone)"
        distanceLabel.text = "< \(hospital!.distance)m"
    }
    @IBAction func swipeRightToExit(sender: UISwipeGestureRecognizer) {
    }

}
