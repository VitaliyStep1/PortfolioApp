//
//  InterfaceLanguageManager.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 26.11.2021.
//

import Foundation

class InterfaceLanguageManager {
    
    enum InterfaceLanguageEnum: String, CaseIterable {
        case english = "en"
        case ukrainian = "uk"
        case russian = "ru"
        
        var languageTitle: String {
            switch self {
            case .english:
                return "English"
            case .ukrainian:
                return "Ukrainian"
            case .russian:
                return "Russian"
            }
        }
    }
    
    func getActiveLanguage() -> InterfaceLanguageEnum {
        var language = InterfaceLanguageEnum.english
        let code = InterfaceLanguageUserDefaults.getActiveLanguageCode()
        if code != nil {
            let loadedLanguage = InterfaceLanguageEnum(rawValue: code!)
            if loadedLanguage != nil {
                language = loadedLanguage!
            }
        }
        
        return language
    }
    
    func getActiveLanguageCode() -> String {
        let activeLanguage = getActiveLanguage()
        return activeLanguage.rawValue
    }
    
    func saveActiveLanguage(language: InterfaceLanguageEnum) {
        let languageCode = language.rawValue
        InterfaceLanguageUserDefaults.saveActiveLanguageCode(code: languageCode)
    }
    
    func getAllInterfaceLanguages() -> [InterfaceLanguageEnum] {
        return InterfaceLanguageEnum.allCases
    }
}
