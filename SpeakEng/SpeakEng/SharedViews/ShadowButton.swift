//
//  ShadowButton.swift
//
//
//  Created by Vitaliy Stepanenko on 3/3/20.
//  Copyright © 2020 Vitaliy Stepanenko. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }

    fileprivate func updateLayerProperties() {
        dropShadow(scale: true)
    }
    
    fileprivate func dropShadow(scale: Bool = true) {
        let color = UIColor.black
        let opacity:Float = 0.2
        let offSet = CGSize(width: -2, height: 5)
        let radius:CGFloat = 5
        dropShadow(color: color, opacity: opacity, offSet: offSet, radius: radius, scale: scale)
    }
    
    fileprivate func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        // layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
