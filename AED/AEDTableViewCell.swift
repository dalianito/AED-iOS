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
        specificLocationLabel.text = aed.specificLocation
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
