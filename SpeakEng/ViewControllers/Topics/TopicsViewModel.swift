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
    var topicsSubject = CurrentValueSubject<[TopicsModel.Topic], Never>([])
    
    @Published private(set) var isShowLoadingIndicator = false
    
    let questionsManager = QuestionsManager.shared
    let textLanguageManager = TextLanguageManager()
    
    init(router: TopicsRouter) {
        self.router = router
    }
    
    func menuButtonClicked() {
        router.showMenu()
    }
    
    func viewWillAppeared() {
        loadTopicsFromServer()
        questionsManager.updateQuestionsFromServerIfNecessary()
    }
    
    func loadTopicsFromServer() {
        let textLanguageId = textLanguageManager.getActiveLanguageId()
        isShowLoadingIndicator = true
        firstly {
            DataService.getTopics(languageId: textLanguageId)
        }.done { [weak self] topicsResponses in
            let sortedTopicsResponses = topicsResponses.sorted {
                $0.sort < $1.sort
            }
            let topics = sortedTopicsResponses.map({ topicsResponse in
                TopicsModel.Topic(id: topicsResponse.id, title: topicsResponse.title)
            })
            self?.topicsSubject.send(topics)
        }.ensure { [weak self] in
            self?.isShowLoadingIndicator = false
        }.catch { [weak self] error in
            let errorMessage = "Some error happened.".localized() + " " + error.localizedDescription
            self?.router.showErrorAlert(message: errorMessage)
        }
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
