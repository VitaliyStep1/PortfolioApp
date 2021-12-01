//
//  QuestionRouter.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 16.11.2021.
//

import UIKit

class QuestionRouter {
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func takeViewController() -> UIViewController {
        let vc = instantiateVC()
        let vm = QuestionViewModel(router: self)
        vc.viewModel = vm
        return vc
    }
    
    func instantiateVC() -> QuestionViewController {
        let storyboard = UIStoryboard(name: "Question", bundle: .main)
        let identifier = "QuestionViewController"
        let vc = storyboard.instantiateViewController(identifier: identifier) as! QuestionViewController
        return vc
    }
    
    func showMenu() {
        appCoordinator?.showMenu()
    }
    
    func closeVC() {
        appCoordinator?.closeVC()
    }
}
