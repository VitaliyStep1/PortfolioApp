//
//  QuestionsManager.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 30.11.2021.
//

import Foundation
import PromiseKit

class QuestionsManager {
    static let shared = QuestionsManager()
    
    fileprivate init() {}
    
    let updateQuestionsUserDefaults = UpdateQuestionsUserDefaults()
    let textLanguageManager = TextLanguageManager()
    let translatesLanguageManager = TranslatesLanguageManager()
    
    func updateQuestionsFromServerIfNecessary() {
        if isNecessaryToUpdateQuestionsForActiveTextLanguage() || isNecessaryToUpdateQuestionsForActiveTranslatesLanguage() {
            updateQuestionsFromServer()
        }
    }
    
    private func isNecessaryToUpdateQuestionsForActiveTextLanguage() -> Bool {
        let textLanguageId = textLanguageManager.getActiveLanguageId()
        let textUpdatedQuestionsDate = updateQuestionsUserDefaults.getUpdatedQuestionsDate(languageId: textLanguageId)
        let isNecessaryUpdate = !wasUpdateToday(date: textUpdatedQuestionsDate)
        return isNecessaryUpdate
    }
    
    private func isNecessaryToUpdateQuestionsForActiveTranslatesLanguage() -> Bool {
        let translatesLanguageId = translatesLanguageManager.getActiveLanguageId()
        let translatesUpdatedQuestionsDate = updateQuestionsUserDefaults.getUpdatedQuestionsDate(languageId: translatesLanguageId)
        let isNecessaryUpdate = !wasUpdateToday(date: translatesUpdatedQuestionsDate)
        return isNecessaryUpdate
    }
    
    private func wasUpdateToday(date: Date?) -> Bool {
        if date != nil, Calendar.current.isDateInToday(date!) {
            return true
        }
        return false
    }
    
    func updateQuestionsFromServer() {
        let textLanguageId = textLanguageManager.getActiveLanguageId()
        let translatesLanguageId = translatesLanguageManager.getActiveLanguageId()
        firstly {
            DataService.getQuestions(mainLanguageId: textLanguageId, translationLanguageId: translatesLanguageId)
        }.done { [weak self] questionsResponse in
            if let self = self {
                let questions1 = questionsResponse.questions1
                let isSuccess1 = self.saveQuestionsToLocalDB(questions: questions1)
                if isSuccess1 {
                    self.saveUpdatedDate(languageId: textLanguageId)
                }
                let questions2 = questionsResponse.questions2
                let isSuccess2 = self.saveQuestionsToLocalDB(questions: questions2)
                if isSuccess2 {
                    self.saveUpdatedDate(languageId: translatesLanguageId)
                }
            }
        }.catch { error in
            //TODO: Do anything else?
            print(error.localizedDescription)
        }
    }
    
    private func saveUpdatedDate(languageId: Int) {
        let date = Date()
        updateQuestionsUserDefaults.saveUpdatedQuestionsDate(date: date, languageId: languageId)
    }
    
    private func saveQuestionsToLocalDB(questions: [QuestionsResponse.Question]) -> Bool {
        return false
    }
}
