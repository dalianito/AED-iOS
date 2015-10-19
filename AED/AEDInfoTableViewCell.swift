//
//  AEDInfoTableViewCell.swift
//  AED
//
//  Created by Yang Yu on 10/8/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class AEDInfoTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var specificLocationLabel: UILabel!
    
    var aed : AEDModel!
    
    // MARK: Actions
    func setView() {
        floorLabel.text = aed.floor
        specificLocationLabel.text = aed.specificLocation
        specificLocationLabel.frame.size.width = self.frame.width - 100.0
    }
}
