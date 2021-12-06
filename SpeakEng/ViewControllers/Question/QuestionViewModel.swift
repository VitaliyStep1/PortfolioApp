//
//  QuestionViewModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import Foundation

class QuestionViewModel {
    var router: QuestionRouter
    
    @Published private(set) var question: QuestionModel.Question?
    @Published private(set) var translatedQuestion: QuestionModel.Question?
    @Published private(set) var topic: QuestionModel.Topic?
    @Published private(set) var isTranslationVisible: Bool = false
    lazy var questionsManager = QuestionsManager.shared
    lazy var translationUserDefaults = TranslationUserDefaults()
    
    init(router: QuestionRouter) {
        self.router = router
    }
    
    func viewWillAppeared() {
        showNextQuestion()
        updateTranslationVisibility()
    }
    
    func showNextQuestion() {
        let questionAndTranslationAndTopic = questionsManager.takeRandomQuestionAndTranslationAndTopic()
        if let question = questionAndTranslationAndTopic.question {
            self.question = QuestionModel.Question(questionId: question.questionId, title: question.title, sort: question.sort, topicId: question.topicId)
            if let translatedQuestion = questionAndTranslationAndTopic.translatedQuestion {
                self.translatedQuestion = QuestionModel.Question(questionId: translatedQuestion.questionId, title: translatedQuestion.title, sort: translatedQuestion.sort, topicId: translatedQuestion.topicId)
            }
            else {
                self.translatedQuestion = nil
            }
            if let topic = questionAndTranslationAndTopic.topic {
                self.topic = QuestionModel.Topic(id: topic.topicId, title: topic.title)
            }
        }
        else {
            self.question = nil
            self.translatedQuestion = nil
            self.topic = nil
        }

    }
    
    func menuButtonClicked() {
        router.showMenu()
    }
    
    func backButtonClicked() {
        router.closeVC()
    }
    
    func nextQuestionButtonClick() {
        showNextQuestion()
    }
    
    func hideTranslationViewButtonClicked() {
        translationUserDefaults.saveIsShowTranslation(isShow: false)
        updateTranslationVisibility()
    }
    
    func languageTranslationViewButtonClicked() {
        //TODO: Add this feature if necessary
    }
    
    func showTranslationViewButtonClicked() {
        translationUserDefaults.saveIsShowTranslation(isShow: true)
        updateTranslationVisibility()
    }
    
    private func updateTranslationVisibility() {
        let isShow = translationUserDefaults.getIsShowTranslation()
        isTranslationVisible = isShow
    }
}
