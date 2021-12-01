//
//  TopicViewModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import Foundation
import Combine

class TopicViewModel {
    var router: TopicRouter
    var topicId: Int?
    @Published var topicTitle: String?
    
    init(router: TopicRouter) {
        self.router = router
    }
    
    func menuButtonClicked() {
        router.showMenu()
    }
    
    func backButtonClicked() {
        router.closeVC()
    }
}
