//
//  TextLanguageUserDefaults.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 29.11.2021.
//

import Foundation

class TextLanguageUserDefaults {
    private let activeLanguageIdKey = "ActiveTextLanguageIdKey"
    
    func saveActiveLanguageId(languageId: Int) {
        UserDefaults.standard.setValue(languageId, forKey: activeLanguageIdKey)
    }
    
    func getActiveLanguageId() -> Int? {
        let languageId = UserDefaults.standard.integer(forKey: activeLanguageIdKey)
        return languageId
    }
}
