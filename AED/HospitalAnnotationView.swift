//
//  HospitalAnnotationView.swift
//  AED
//
//  Created by Yang Yu on 10/21/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class HospitalAnnotationView: MAAnnotationView {
    
    
    //var calloutView: BuildingCalloutCell?
    var customProperties: [String: AnyObject?]?
    var indexNumber: NSInteger?
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if annotation.isKindOfClass(CustomAnnotation) {
            setCustomAnnotation(annotation as! CustomAnnotation)
        } else {
            indexNumber = 0
            setImageWithIndex(self.indexNumber!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let customAnnotation = self.annotation as! CustomAnnotation
        indexNumber = customAnnotation.sequenceNumber
        setImageWithIndex(self.indexNumber!)
    }
    
    func setCustomAnnotation(annotation: CustomAnnotation) {
        self.customProperties = annotation.customProperties
        self.indexNumber = annotation.sequenceNumber
        setImageWithIndex(self.indexNumber!)
    }
    
    func setImageWithIndex(index: NSInteger) {
        if (index >= 0 && index < 11) {
            if (self.selected) {
                self.image = UIImage(named: "waterBlue\(index+1)")
            } else {
                self.image = UIImage(named: "waterRed\(index+1)")
            }
        } else {
            if self.selected {
                self.image = UIImage(named: "waterBlueBlank")
            } else {
                self.image = UIImage(named: "waterRedBlank")
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setImageWithIndex(self.indexNumber!)
    }

}
