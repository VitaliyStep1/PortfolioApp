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
    lazy var textLanguageManager = TextLanguageManager()
    lazy var updateTopicsUserDefaults = UpdateTopicsUserDefaults()
    lazy var topicsCoreDataManager = TopicsCoreDataManager.shared
    
    var loadingTopicsForLanguagesIdSetSubject = CurrentValueSubject<Set<Int>, Never>([])
    
    fileprivate init() {}
    
    func updateTopicsFromServerIfNecessary() {
        if isNecessaryUpdateToUpdateQuestionsForActiveLanguage() {
            updateTopicsFromServer()
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
    
    func updateTopicsFromServer() {
        let languageId = textLanguageManager.getActiveLanguageId()
        if !loadingTopicsForLanguagesIdSetSubject.value.contains(languageId) {
            loadingTopicsForLanguagesIdSetSubject.value.insert(languageId)
            firstly {
                DataService.getTopics(languageId: languageId)
            }.done { [weak self] topicsResponses in
                if let self = self {
                    let topics = topicsResponses.map { topicsResponse in
                        Topic(topicId: topicsResponse.id, title: topicsResponse.title, sort: topicsResponse.sort, languageId: topicsResponse.languageId)
                    }
                    if self.saveTopicsToLocalDB(topics: topics) {
                        self.saveUpdatedDate(languageId: languageId)
                    }
                }
            }.ensure { [weak self] in
                self?.loadingTopicsForLanguagesIdSetSubject.value.remove(languageId)
            }.catch { error in
                //TODO: Do anything else?
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveUpdatedDate(languageId: Int) {
        let date = Date()
        updateTopicsUserDefaults.saveUpdatedTopicsDate(date: date, languageId: languageId)
    }
    
    func saveTopicsToLocalDB(topics: [Topic]) -> Bool {
        let isSuccess = topicsCoreDataManager.addTopics(topics: topics)
        return isSuccess
    }
    
    func takeTopics() -> [Topic] {
        let languageId = textLanguageManager.getActiveLanguageId()
        let topics = topicsCoreDataManager.takeAllTopics(languageId: languageId)
        return topics ?? []
    }
    
    func takeTopic(topicId: Int) -> Topic? {
        let languageId = textLanguageManager.getActiveLanguageId()
        let topic = topicsCoreDataManager.takeTopic(languageId: languageId, topicId: topicId)
        return topic
    }
}
