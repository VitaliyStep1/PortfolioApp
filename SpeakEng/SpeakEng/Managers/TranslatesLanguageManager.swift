//
//  TranslatesLanguageManager.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 30.11.2021.
//

import Foundation

class TranslatesLanguageManager {
    let translatesLanguageUserDefaults = TranslatesLanguageUserDefaults()
    private let defaultTranslatesLanguageId = 1
    
    func saveActiveLanguageId(languageId: Int) {
        translatesLanguageUserDefaults.saveActiveLanguageId(languageId: languageId)
    }
    
    func getActiveLanguageId() -> Int {
        let activeLanguageId = translatesLanguageUserDefaults.getActiveLanguageId()
        return activeLanguageId ?? defaultTranslatesLanguageId
    }
}
