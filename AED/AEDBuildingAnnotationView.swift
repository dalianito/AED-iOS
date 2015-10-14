//
//  AEDBuildingAnnotationView.swift
//  AED
//
//  Created by Yang Yu on 10/14/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class AEDBuildingAnnotationView: MAPinAnnotationView {
    
    var calloutView: BuildingCalloutCell?
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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



}
