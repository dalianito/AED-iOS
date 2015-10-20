//
//  AEDTableViewCell.swift
//  AED
//
//  Created by Yang Yu on 10/15/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class AEDTableViewCell: UITableViewCell {
    // MARK: Properties
    
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var specificLocationLabel: UILabel!
    
    var aed : AEDModel!
    
    // MARK: Actions
    func setView() {
        floorLabel.text = aed.floor
        
        specificLocationLabel.frame.size.width = self.frame.width - 100.0
        specificLocationLabel.numberOfLines = 10
        
        specificLocationLabel.frame.size.height = 200
        specificLocationLabel.text = aed.specificLocation
    }
}
