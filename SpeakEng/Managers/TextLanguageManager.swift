//
//  TextLanguageManager.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 30.11.2021.
//

import Foundation

class TextLanguageManager {
    let textLanguageUserDefaults = TextLanguageUserDefaults()
    private let defaultTextLanguageId = 1
    lazy var topicsManager = TopicsManager.shared
    lazy var questionsManager = QuestionsManager.shared
    
    func changeActiveLanguageId(languageId: Int) {
        saveActiveLanguageId(languageId: languageId)
        topicsManager.updateTopicsFromServer()
        questionsManager.updateQuestionsFromServer()
    }
    
    private func saveActiveLanguageId(languageId: Int) {
        textLanguageUserDefaults.saveActiveLanguageId(languageId: languageId)
    }
    
    func getActiveLanguageId() -> Int {
        let activeLanguageId = textLanguageUserDefaults.getActiveLanguageId()
        return activeLanguageId ?? defaultTextLanguageId
    }
}
