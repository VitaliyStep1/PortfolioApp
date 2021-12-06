//
//  TopicViewModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import Foundation
import Combine

class TopicViewModel {
    private var subscriptions = Set<AnyCancellable>()
    var router: TopicRouter
    var topicId: Int?
    @Published var topicTitle: String?
    @Published private(set) var translatedQuestion: Question?
    @Published private(set) var isTranslationVisible: Bool = false
    var questionsSubject = CurrentValueSubject<[TopicModel.Question], Never>([])
    var selectedRowSubject = CurrentValueSubject<Int, Never>(0)
    lazy var questionsManager = QuestionsManager.shared
    lazy var translationUserDefaults = TranslationUserDefaults()
    
    init(router: TopicRouter) {
        self.router = router
        bind()
    }
    
    func bind() {
        questionsSubject.sink { [weak self] questions in
            self?.loadTranslatedQuestion()
        }.store(in: &subscriptions)
        
        selectedRowSubject.sink { [weak self] rowIndex in
            self?.loadTranslatedQuestion()
        }.store(in: &subscriptions)
    }
    
    func viewWillAppeared() {
        loadQuestions()
        updateTranslationVisibility()
    }
    
    func menuButtonClicked() {
        router.showMenu()
    }
    
    func backButtonClicked() {
        router.closeVC()
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
    
    private func loadQuestions() {
        guard let topicId = self.topicId else {
            return
        }
        let questions = questionsManager.takeQuestions(topicId: topicId) ?? []
        let topicQuestions = questions.map { question in
            TopicModel.Question(questionId: question.questionId, title: question.title, sort: question.sort, topicId: question.topicId)
        }
        self.questionsSubject.send(topicQuestions)
    }
    
    private func loadTranslatedQuestion() {
        let questions = questionsSubject.value
        let row = selectedRowSubject.value
        if questions.count > row {
            let question = questions[row]
            let translatedQuestion = questionsManager.takeTranlatedQuestion(questionId: question.questionId)
            self.translatedQuestion = translatedQuestion
        }
    }
}

extension TopicViewModel {
    func takeRowsAmount(section: Int) -> Int {
        let rowsAmount = questionsSubject.value.count
        return rowsAmount
    }
    
    func takeCellInfo(row: Int) -> (title: String, isSelected: Bool) {
        let question = questionsSubject.value[row]
        let number = row + 1
        let title = "\(number). " + question.title
        let isSelected = row == selectedRowSubject.value
        return (title: title, isSelected: isSelected)
    }
    
    func cellWasSelected(row: Int) {
        selectedRowSubject.send(row)
    }
}
