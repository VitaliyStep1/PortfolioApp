//
//  QuestionViewModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import Foundation

class QuestionViewModel {
    var router: QuestionRouter
    
    init(router: QuestionRouter) {
        self.router = router
    }
    
    func menuButtonClicked() {
        router.showMenu()
    }
    
    func backButtonClicked() {
        router.closeVC()
    }
}
