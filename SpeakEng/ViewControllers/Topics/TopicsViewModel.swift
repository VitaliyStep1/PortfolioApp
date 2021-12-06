//
//  TopicsViewModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import Foundation
import PromiseKit
import Combine

class TopicsViewModel {
    var router: TopicsRouter
    let sections: [TopicsModel.SectionType] = [
        .randomQuestion,
        .randomTopic,
        .topic
    ]
    private var subscriptions = Set<AnyCancellable>()
    var topicsSubject = CurrentValueSubject<[TopicsModel.Topic], Never>([])
    
    @Published private(set) var isShowLoadingIndicator = false
    
    let questionsManager = QuestionsManager.shared
    lazy var textLanguageManager = TextLanguageManager()
    lazy var topicsManager = TopicsManager.shared
    
    init(router: TopicsRouter) {
        self.router = router
    }
    
    func viewDidLoaded() {
        bind()
    }
    
    private func bind() {
        topicsManager.loadingTopicsForLanguagesIdSetSubject.sink { [weak self] languagesIdSet in
            guard let self = self else {
                return
            }
            let languageId = self.textLanguageManager.getActiveLanguageId()
            self.isShowLoadingIndicator = languagesIdSet.contains(languageId)
            self.takeTopicsFromDB()
        }.store(in: &subscriptions)
    }
    
    func menuButtonClicked() {
        router.showMenu()
    }
    
    func viewWillAppeared() {
        takeTopicsFromDB()
        topicsManager.updateTopicsFromServerIfNecessary()
        questionsManager.updateQuestionsFromServerIfNecessary()
    }
    
    func takeTopicsFromDB() {
        let topics = topicsManager.takeTopics()
        let topics1 = topics.map { topic in
            TopicsModel.Topic(id: topic.topicId, title: topic.title)
        }
        topicsSubject.send(topics1)
    }
}

extension TopicsViewModel {
    func takeSectionsAmount() -> Int {
        let sectionsAmount = sections.count
        return sectionsAmount
    }
    
    func takeRowsAmount(section: Int) -> Int {
        let sectionType = sections[section]
        var rowsAmount = 0
        
        switch sectionType {
        case .randomQuestion:
            rowsAmount = 1
        case .randomTopic:
            if topicsSubject.value.count > 0 {
                rowsAmount = 1
            }
            else {
                rowsAmount = 0
            }
        case .topic:
            rowsAmount = topicsSubject.value.count
        }
        return rowsAmount
    }
    
    func takeCellInfo(section: Int, row: Int) -> (sectionType: TopicsModel.SectionType, imageName: String, title: String) {
        let sectionType = sections[section]
        var imageName = ""
        var title = ""
        
        switch sectionType {
        case .randomQuestion:
            title = "Random question".localized()
            imageName = ""
        case .randomTopic:
            title = "Random topic".localized()
            imageName = ""
        case .topic:
            let topic = topicsSubject.value[row]
            title = topic.title
            imageName = ""
        }
        return (sectionType: sectionType, imageName: imageName, title: title)
    }
    
    func cellWasSelected(section: Int, row: Int) {
        let sectionType = sections[section]
        switch sectionType {
        case .randomQuestion:
            router.showQuestionScreen()
        case .randomTopic:
            showRandomTopicScreen()
        case .topic:
            let topic = topicsSubject.value[row]
            router.showTopicScreen(topicId: topic.id, topicTitle: topic.title)
        }
    }
    
    func showRandomTopicScreen() {
        let randomTopic = topicsSubject.value.randomElement()
        if let topicId = randomTopic?.id, let topicTitle = randomTopic?.title {
            router.showRandomTopicScreen(topicId: topicId, topicTitle: topicTitle)
        }
        else {
            //TODO: Show some error?
        }
    }
}
