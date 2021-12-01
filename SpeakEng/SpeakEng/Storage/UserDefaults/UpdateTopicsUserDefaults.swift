//
//  UpdateTopicsUserDefaults.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 01.12.2021.
//

import Foundation

class UpdateTopicsUserDefaults {
    private let updatedTopicsDateKey = "UpdatedTopicsDateKey"
    
    func saveUpdatedTopicsDate(date: Date, languageId: Int) {
        let key = getKey(languageId: languageId)
        UserDefaults.standard.setValue(date, forKey: key)
    }
    
    func getUpdatedTopicsDate(languageId: Int) -> Date? {
        let key = getKey(languageId: languageId)
        let date = UserDefaults.standard.value(forKey: key) as? Date
        return date
    }
    
    private func getKey(languageId: Int) -> String {
        let key = updatedTopicsDateKey + "\(languageId)"
        return key
    }
}
