//
//  StringExtensions.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 26.11.2021.
//

import Foundation

extension String {
    func localized() -> String {
        let interfaceLanguageManager = InterfaceLanguageManager()
        let languageCode = interfaceLanguageManager.getActiveLanguageCode()
        return self.localized(languageCode: languageCode)
    }
    
    private func localized(languageCode: String) -> String {
        
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "*\(self)*", comment: "")
    }
}
