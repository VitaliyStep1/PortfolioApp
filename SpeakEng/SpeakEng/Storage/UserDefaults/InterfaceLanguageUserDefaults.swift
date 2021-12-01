//
//  InterfaceLanguageUserDefaults.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 26.11.2021.
//

import Foundation

class InterfaceLanguageUserDefaults {
    static private let activeLanguageCodeKey = "ActiveInterfaceLanguageCodeKey"
    
    static func saveActiveLanguageCode(code: String) {
        UserDefaults.standard.setValue(code, forKey: activeLanguageCodeKey)
    }
    
    static func getActiveLanguageCode() -> String? {
        let code = UserDefaults.standard.string(forKey: activeLanguageCodeKey)
        return code
    }
}
