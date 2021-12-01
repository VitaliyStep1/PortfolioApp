//
//  SettingsModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 24.11.2021.
//

import Foundation

struct SettingsModel {
    enum SettingsCellType {
        case interfaceLanguage
        case textLanguage
        case translateLanguage
    }
    
    struct SettingsItem {
        let cellType: SettingsCellType
        let imageName: String
        let title: String
        
        init(_ cellType: SettingsCellType, _ imageName: String, _ title: String) {
            self.cellType = cellType
            self.imageName = imageName
            self.title = title
        }
    }
    
    struct InterfaceLanguage: ToolBarPickerViewItem {
        let language: InterfaceLanguageManager.InterfaceLanguageEnum
        let title: String
    }
    
    struct TextLanguage: ToolBarPickerViewItem {
        let id: Int
        let name: String
        let title: String
    }
    
}
