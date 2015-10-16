//
//  BuildingCalloutCell.swift
//  AED
//
//  Created by Yang Yu on 10/14/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class BuildingCalloutCell: UIView {
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var infoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubViews()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func initSubViews() {
        self.backgroundColor = UIColor.whiteColor()
        
        titleLabel = UILabel.init(frame: CGRectMake(CGFloat(kPortraitMargin), CGFloat(kPortraitMargin), CGFloat(kTitleWidth), CGFloat(kTitleHeight)))
        
        subtitleLabel = UILabel.init(frame: CGRectMake(CGFloat(kPortraitMargin), CGFloat(kPortraitMargin*2 + kTitleHeight), CGFloat(kTitleWidth), CGFloat(kTitleHeight)))
    }
    
    func adjustViewSize() {
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        infoImageView = UIImageView.init(image: UIImage(named: "info"))
        infoImageView.frame = CGRectMake(CGFloat(kPortraitMargin*2) + fmax(titleLabel.frame.width, subtitleLabel.frame.width), 7.5, 30, 30)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(infoImageView)
        
        self.frame.size.width = CGFloat(kPortraitMargin*3) + titleLabel.frame.width + infoImageView.frame.width
    }
    
    let kPortraitMargin =    5
    let kPortraitHeight   =  50
    
    let kTitleWidth        = 190
    let kTitleHeight      =  20
    
    @IBInspectable var cornerRadius      : CGFloat = 5
    @IBInspectable var arrowHeight       : CGFloat = 5
    @IBInspectable var arrowAngle        : CGFloat = CGFloat(M_PI_4)
    @IBInspectable var bubbleFillColor   : UIColor = UIColor.whiteColor()
    @IBInspectable var bubbleStrokeColor : UIColor = UIColor.whiteColor()
    @IBInspectable var bubbleLineWidth   : CGFloat = 1
    
    let contentView = UIView()
    
    
    private func configure() {
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        addSubview(contentView)
    }
    
    override func layoutSubviews() {
        let contentViewFrame = CGRect(x: cornerRadius, y: cornerRadius, width: frame.size.width - cornerRadius * 2.0, height: frame.size.height - cornerRadius * 2.0 - arrowHeight)
        
        contentView.frame = contentViewFrame
    }
    
    func setContentViewSize(size: CGSize) {
        var bubbleFrame = self.frame
        bubbleFrame.size = CGSize(width: size.width + cornerRadius * 2.0, height: size.height + cornerRadius * 2.0 + arrowHeight)
        frame = bubbleFrame
        setNeedsDisplay()
    }
    
    // draw the callout/popover/bubble with rounded corners and an arrow pointing down (presumably to the item below this)
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        let start = CGPointMake(frame.size.width / 2.0, frame.size.height)
        
        path.moveToPoint(start)
        
        // right side of arrow
        
        var point = CGPointMake(start.x + CGFloat(arrowHeight * tan(arrowAngle)), start.y - arrowHeight - bubbleLineWidth)
        path.addLineToPoint(point)
        
        // lower right
        
        point.x = frame.size.width - cornerRadius - bubbleLineWidth / 2.0
        path.addLineToPoint(point)
        
        // lower right corner
        
        point.x += cornerRadius
        var controlPoint = point
        point.y -= cornerRadius
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        
        // right
        
        point.y -= frame.size.height - arrowHeight - cornerRadius * CGFloat(2.0) - bubbleLineWidth * CGFloat(1.5)
        path.addLineToPoint(point)
        
        // upper right corner
        
        point.y -= cornerRadius
        controlPoint = point
        point.x -= cornerRadius
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        
        // top
        
        point.x -= (frame.size.width - cornerRadius * 2.0 - bubbleLineWidth)
        path.addLineToPoint(point)
        
        var lowerLeftPoint = point
        lowerLeftPoint.y += cornerRadius
        
        // top left corner
        
        point.x -= cornerRadius
        controlPoint = point
        point.y += cornerRadius
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        
        // left
        
        point.y += frame.size.height - arrowHeight - cornerRadius * CGFloat(2.0) - bubbleLineWidth * CGFloat(1.5)
        path.addLineToPoint(point)
        
        // lower left corner
        
        point.y += cornerRadius
        controlPoint = point
        point.x += cornerRadius
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        
        // lower left
        
        point = CGPointMake(start.x - CGFloat(arrowHeight * tan(arrowAngle)), start.y - arrowHeight - bubbleLineWidth)
        path.addLineToPoint(point)
        
        // left side of arrow
        
        path.closePath()
        
        // draw the callout bubble
        
        bubbleFillColor.setFill()
        bubbleStrokeColor.setStroke()
        path.lineWidth = bubbleLineWidth
        
        path.fill()
        path.stroke()
    }
}
