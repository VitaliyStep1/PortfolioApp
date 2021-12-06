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
    
    lazy var updateQuestionsUserDefaults = UpdateQuestionsUserDefaults()
    lazy var textLanguageManager = TextLanguageManager()
    lazy var translatesLanguageManager = TranslatesLanguageManager()
    lazy var questionsCoreDataManager = QuestionsCoreDataManager.shared
    lazy var topicsManager = TopicsManager.shared
    
    var loadingQuestionsForLanguagesIdSet = Set<Int>()
    
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
        if !loadingQuestionsForLanguagesIdSet.contains(textLanguageId) || !loadingQuestionsForLanguagesIdSet.contains(translatesLanguageId) {
            loadingQuestionsForLanguagesIdSet.insert(textLanguageId)
            loadingQuestionsForLanguagesIdSet.insert(translatesLanguageId)
        firstly {
            DataService.getQuestions(mainLanguageId: textLanguageId, translationLanguageId: translatesLanguageId)
        }.done { [weak self] questionsResponse in
            if let self = self {
                let questions1 = questionsResponse.questions1
                let isSuccess1 = self.saveQuestionsToLocalDB(responseQuestions: questions1)
                if isSuccess1 {
                    self.saveUpdatedDate(languageId: textLanguageId)
                }
                let questions2 = questionsResponse.questions2
                let isSuccess2 = self.saveQuestionsToLocalDB(responseQuestions: questions2)
                if isSuccess2 {
                    self.saveUpdatedDate(languageId: translatesLanguageId)
                }
            }
        }.ensure { [weak self] in
            self?.loadingQuestionsForLanguagesIdSet.remove(textLanguageId)
            self?.loadingQuestionsForLanguagesIdSet.remove(translatesLanguageId)
        } .catch { error in
            //TODO: Do anything else?
            print(error.localizedDescription)
        }
        }
    }
    
    private func saveUpdatedDate(languageId: Int) {
        let date = Date()
        updateQuestionsUserDefaults.saveUpdatedQuestionsDate(date: date, languageId: languageId)
    }
    
    private func saveQuestionsToLocalDB(responseQuestions: [QuestionsResponse.Question]) -> Bool {
        let questions = responseQuestions.compactMap { responseQuestion -> Question? in
            guard let questionId = responseQuestion.id,
                  let sort = responseQuestion.sort,
                  let topicId = responseQuestion.topicId,
                  let languageId = responseQuestion.languageId else {
                return nil
            }
            let question = Question(questionId: questionId, title: responseQuestion.title, sort: sort, topicId: topicId, languageId: languageId)
            return question
        }
        let isSuccess = questionsCoreDataManager.addQuestions(questions: questions)
        
        return isSuccess
    }
    
    func takeRandomQuestionAndTranslationAndTopic() -> (question: Question?, translatedQuestion: Question?, topic: Topic?) {
        let textLanguageId = textLanguageManager.getActiveLanguageId()
        let question = questionsCoreDataManager.takeRandomQuestion(languageId: textLanguageId)
        var translatedQuestion: Question? = nil
        if let questionId = question?.questionId {
            let translatesLanguageId = translatesLanguageManager.getActiveLanguageId()
            translatedQuestion = questionsCoreDataManager.takeQuestion(questionId: questionId, languageId: translatesLanguageId)
        }
        var topic: Topic? = nil
        if let topicId = question?.topicId {
            topic = topicsManager.takeTopic(topicId: topicId)
        }
        
        return (question: question, translatedQuestion: translatedQuestion, topic: topic)
    }
    
    func takeQuestions(topicId: Int) -> [Question]? {
        let textLanguageId = textLanguageManager.getActiveLanguageId()
        let questions = questionsCoreDataManager.takeQuestions(languageId: textLanguageId, topicId: topicId)
        return questions
    }
    
    func takeTranlatedQuestion(questionId: Int) -> Question? {
        let languageId = translatesLanguageManager.getActiveLanguageId()
        let question = questionsCoreDataManager.takeQuestion(questionId: questionId, languageId: languageId)
        return question
    }
}
