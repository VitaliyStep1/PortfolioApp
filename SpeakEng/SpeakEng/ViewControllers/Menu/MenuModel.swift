//
//  MenuModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 19.11.2021.
//

import Foundation

struct MenuModel {
    enum MenuCellType {
        case topics
        case settings
        case sendEmail
        case review
    }
    
    struct MenuItem {
        let cellType: MenuCellType
        let imageName: String
        let title: String
        
        init(_ cellType: MenuCellType, _ imageName: String, _ title: String) {
            self.cellType = cellType
            self.imageName = imageName
            self.title = title
        }
    }
}
