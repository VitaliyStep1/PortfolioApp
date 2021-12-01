//
//  Scalable.swift
//  
//
//  Created by Vitaliy Stepanenko on 4/4/20.
//  Copyright © 2020 Vitaliy Stepanenko. All rights reserved.
//

import Foundation
import UIKit

struct Scalable {
    private static var basicScreenWidth: CGFloat {
        return Constants.Scalable.basicScreenWidth
    }
    
    private static var basicIpadScreenWidth: CGFloat {
        return Constants.Scalable.basicIpadScreenWidth
    }
    
    static var scale: CGFloat = {
        var screenWidth = basicScreenWidth
        if Scalable.isIpad() {
            screenWidth = basicIpadScreenWidth
        }
        let currentScreenWidth: CGFloat = UIScreen.main.bounds.width
        let value = currentScreenWidth / screenWidth
        return value
    }()
    
    static func isIpad() -> Bool {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        return isIpad
    }
}
