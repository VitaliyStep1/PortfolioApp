//
//  TopicRouter.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 16.11.2021.
//

import UIKit

class TopicRouter {
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func takeViewController(topicId: Int, topicTitle: String) -> UIViewController {
        let vc = instantiateVC()
        let vm = TopicViewModel(router: self)
        vm.topicId = topicId
        vm.topicTitle = topicTitle
        vc.viewModel = vm
        return vc
    }
    
    func instantiateVC() -> TopicViewController {
        let storyboard = UIStoryboard(name: "Topic", bundle: .main)
        let identifier = "TopicViewController"
        let vc = storyboard.instantiateViewController(identifier: identifier) as! TopicViewController
        return vc
    }
    
    func showMenu() {
        appCoordinator?.showMenu()
    }
    
    func closeVC() {
        appCoordinator?.closeVC()
    }
}
