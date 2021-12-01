//
//  MenuRouter.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 16.11.2021.
//

import UIKit
import MessageUI

class MenuRouter: NSObject {
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func takeViewController() -> UIViewController {
        let vc = instantiateVC()
        let vm = MenuViewModel(router: self)
        vc.viewModel = vm
        return vc
    }
    
    func instantiateVC() -> MenuViewController {
        let storyboard = UIStoryboard(name: "Menu", bundle: .main)
        let identifier = "MenuViewController"
        let vc = storyboard.instantiateViewController(identifier: identifier) as! MenuViewController
        return vc
    }
    
    func showTopicsScreen() {
        appCoordinator?.showMenuContentScreen(.topics)
    }
    
    func showSettingsScreen() {
        appCoordinator?.showMenuContentScreen(.settings)
    }
    
    func showSendEmailScreenOrErrorAlert(recipients: [String], message: String, isHTML: Bool, errorMessage: String) {
        if MFMailComposeViewController.canSendMail() {
            appCoordinator?.presentOnMenuScreen(.sendEmail(recipients: recipients, message: message, isHTML: isHTML, delegate: self))
        } else {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func openUrlOrSendErrorAlert(url: URL, errorMessage: String) {
        if appCoordinator?.canOpenUrl(url: url) ?? false {
            appCoordinator?.openUrl(url: url)
        }
        else {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func showErrorAlert(message: String) {
        appCoordinator?.presentOnMenuScreen(.errorAlert(message: message))
    }
}

extension MenuRouter: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
