//
//  UpdateQuestionsUserDefaults.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 30.11.2021.
//

import Foundation

class UpdateQuestionsUserDefaults {
    private let updatedQuestionsDateKey = "UpdatedQuestionsDateKey"
    
    func saveUpdatedQuestionsDate(date: Date, languageId: Int) {
        let key = getKey(languageId: languageId)
        UserDefaults.standard.setValue(date, forKey: key)
    }
    
    func getUpdatedQuestionsDate(languageId: Int) -> Date? {
        let key = getKey(languageId: languageId)
        let date = UserDefaults.standard.value(forKey: key) as? Date
        return date
    }
    
    private func getKey(languageId: Int) -> String {
        let key = updatedQuestionsDateKey + "\(languageId)"
        return key
    }
}
