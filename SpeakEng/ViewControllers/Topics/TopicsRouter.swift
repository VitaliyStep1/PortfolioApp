//
//  TopicsRouter.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 16.11.2021.
//

import UIKit

class TopicsRouter {
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func takeViewController() -> UIViewController {
        let vc = instantiateVC()
        let vm = TopicsViewModel(router: self)
        vc.viewModel = vm
        return vc
    }
    
    func instantiateVC() -> TopicsViewController {
        let storyboard = UIStoryboard(name: "Topics", bundle: .main)
        let identifier = "TopicsViewController"
        let vc = storyboard.instantiateViewController(identifier: identifier) as! TopicsViewController
        return vc
    }
    
    func showQuestionScreen() {
        appCoordinator?.pushVC(.question)
    }
    
    func showRandomTopicScreen(topicId: Int, topicTitle: String) {
        appCoordinator?.pushVC(.topic(topicId: topicId, topicTitle: topicTitle))
    }
    
    func showTopicScreen(topicId: Int, topicTitle: String) {
        appCoordinator?.pushVC(.topic(topicId: topicId, topicTitle: topicTitle))
    }
    
    func showMenu() {
        appCoordinator?.showMenu()
    }
    
    func showErrorAlert(message: String) {
        appCoordinator?.presentOnMenuScreen(.errorAlert(message: message))
    }
}
