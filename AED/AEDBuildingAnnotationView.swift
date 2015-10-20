//
//  AEDBuildingAnnotationView.swift
//  AED
//
//  Created by Yang Yu on 10/14/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class AEDBuildingAnnotationView: MAAnnotationView {

    
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
    /*
    override func setSelected(selected: Bool, animated: Bool) {
        if (self.selected == selected)
        {
            return
        }
        
        if (selected)
        {
            if (self.calloutView == nil)
            {
                self.calloutView = BuildingCalloutCell.init(frame: CGRectMake(0, 0, 200, 55))
            }
            
            //self.calloutView.image = [UIImage imageNamed:@"building"];
            self.calloutView!.titleLabel.text = self.annotation.title!()
            self.calloutView!.titleLabel.font = UIFont(name: self.calloutView!.titleLabel.font.fontName, size: 14)
            self.calloutView!.subtitleLabel.text = self.annotation.subtitle!()
            self.calloutView!.subtitleLabel.font = UIFont(name: self.calloutView!.titleLabel.font.fontName, size: 12)
            self.calloutView!.adjustViewSize()
            self.calloutView!.opaque = true
            
            self.calloutView!.center = CGPointMake(CGRectGetWidth(self.bounds) / 2 + self.calloutOffset.x,
                -CGRectGetHeight(self.calloutView!.bounds) / 2 + self.calloutOffset.y)
            
            self.addSubview(calloutView!)
            self.leftCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        }
        else
        {
            print("removing subview")
            self.calloutView!.removeFromSuperview()
        }
        
        super.setSelected(selected, animated: animated)
    }

    */

}
