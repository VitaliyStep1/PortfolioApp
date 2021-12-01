//
//  SettingsRouter.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 17.11.2021.
//

import UIKit

class SettingsRouter {
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func takeViewController() -> UIViewController {
        let vc = instantiateVC()
        let vm = SettingsViewModel(router: self)
        vc.viewModel = vm
        return vc
    }
    
    func instantiateVC() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Settings", bundle: .main)
        let identifier = "SettingsViewController"
        let vc = storyboard.instantiateViewController(identifier: identifier) as! SettingsViewController
        return vc
    }
    
    func showMenu() {
        appCoordinator?.showMenu()
    }
    
    func showErrorAlert(message: String) {
        appCoordinator?.presentOnMenuScreen(.errorAlert(message: message))
    }
}
