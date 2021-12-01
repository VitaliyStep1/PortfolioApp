//
//  ScalableTextView.swift
//  
//
//  Created by Vitaliy Stepanenko on 4/2/20.
//  Copyright © 2020 Vitaliy Stepanenko. All rights reserved.
//

import UIKit

class ScalableTextView: UITextView {
    
    @IBInspectable var scalableFontSize: Int = 0
    @IBInspectable var scalableFontSizeIpad: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Scalable.isIpad() && scalableFontSizeIpad != 0 {
            let scale = Scalable.scale
            let fontSize = CGFloat(scalableFontSizeIpad) * scale
            let font = super.font
            if font != nil {
                let newFont = font!.withSize(fontSize)
                super.font = newFont
            }
        } else if scalableFontSize != 0 {
            let scale = Scalable.scale
            let fontSize = CGFloat(scalableFontSize) * scale
            let font = super.font
            if font != nil {
                let newFont = font!.withSize(fontSize)
                super.font = newFont
            }
        }
    }
}
