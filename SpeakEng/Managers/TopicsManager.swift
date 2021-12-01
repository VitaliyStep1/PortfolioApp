//
//  TopicsManager.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 01.12.2021.
//

import Foundation
import PromiseKit
import Combine

class TopicsManager {
    static let shared = TopicsManager()
    let textLanguageManager = TextLanguageManager()
    let updateTopicsUserDefaults = UpdateTopicsUserDefaults()
    
    @Published  private(set) var isLoading = false
    
    fileprivate init() {}
    
    func updateTopicsIfNecessary() {
        if isNecessaryUpdateToUpdateQuestionsForActiveLanguage() {
            updateTopics()
        }
    }
    
    func isNecessaryUpdateToUpdateQuestionsForActiveLanguage() -> Bool {
        let activeLanguageId = textLanguageManager.getActiveLanguageId()
        let topicsUpdatedDate = updateTopicsUserDefaults.getUpdatedTopicsDate(languageId: activeLanguageId)
        let isNecessaryUpdate = !wasUpdateToday(date: topicsUpdatedDate)
        return isNecessaryUpdate
    }
    
    private func wasUpdateToday(date: Date?) -> Bool {
        if date != nil, Calendar.current.isDateInToday(date!) {
            return true
        }
        return false
    }
    
    func updateTopics() {
        let languageId = textLanguageManager.getActiveLanguageId()
        isLoading = true
        firstly {
            DataService.getTopics(languageId: languageId)
        }.done { [weak self] topicsResponses in
            if let self = self {
                if self.saveTopicsToLocalDB(topics: topicsResponses) {
                    self.saveUpdatedDate(languageId: languageId)
                }
            }
        }.ensure { [weak self] in
            self?.isLoading = false
        }.catch { error in
            //TODO: Do anything else?
            print(error.localizedDescription)
        }
    }
    
    private func saveUpdatedDate(languageId: Int) {
        let date = Date()
        updateTopicsUserDefaults.saveUpdatedTopicsDate(date: date, languageId: languageId)
    }
    
    func saveTopicsToLocalDB(topics: [TopicsResponse]) -> Bool {
        return false
    }
}
