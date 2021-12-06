//
//  AppCoordinator2.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 16.11.2021.
//

import Foundation
import UIKit
import SideMenuSwift
import MessageUI

enum AppCoordinatorScreen {
    case topics
    case question
    case topic(topicId: Int, topicTitle: String)
    case menu
    case settings
    case errorAlert(message: String)
    case sendEmail(recipients: [String], message: String, isHTML: Bool, delegate: MFMailComposeViewControllerDelegate?)
}

class AppCoordinator {
    private var sideMenuController: SideMenuController?
    
    var rootViewController: UIViewController {
        return sideMenuController!
    }
    
    init() {
        let topicsVC = takeViewController(.topics)
        let contentViewController = MainNavigationController(rootViewController: topicsVC)
        let menuViewController = takeViewController(.menu)
        let baseMenuWidth: CGFloat = 352
        let menuWidth = baseMenuWidth * Scalable.scale
        SideMenuController.preferences.basic.menuWidth = menuWidth
        sideMenuController = SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
    }
    
    func showMenuContentScreen(_ screen: AppCoordinatorScreen) {
        let vc = takeViewController(screen)
        let nc = MainNavigationController(rootViewController: vc)
        sideMenuController?.contentViewController = nc
        sideMenuController?.hideMenu()
    }
    
    func showMenu() {
        sideMenuController?.revealMenu()
    }
    
    func pushVC(_ screen: AppCoordinatorScreen, isAnimated: Bool = true) {
        let targetVC = takeViewController(screen)
        let visibleVC = UIApplication.topViewController(controller: sideMenuController?.contentViewController)
        if let nv = visibleVC?.navigationController {
            nv.pushViewController(targetVC, animated: isAnimated)
        }
        else {
            visibleVC?.modalPresentationStyle = .fullScreen
            visibleVC?.present(targetVC, animated: isAnimated, completion: nil)
        }
    }
    
    func presentFullScreenVC(_ screen: AppCoordinatorScreen, isAnimated: Bool = true) {
        let targetVC = takeViewController(screen)
        let visibleVC = UIApplication.topViewController(controller: sideMenuController?.contentViewController)
        visibleVC?.modalPresentationStyle = .fullScreen
        visibleVC?.present(targetVC, animated: isAnimated, completion: nil)
    }
    
    func closeVC(_ isAnimated: Bool = true) {
        let visibleVC = UIApplication.topViewController(controller: sideMenuController?.contentViewController)
        if visibleVC?.navigationController?.topViewController == visibleVC {
            visibleVC?.navigationController?.popViewController(animated: isAnimated)
        }
        else {
            visibleVC?.dismiss(animated: isAnimated, completion: nil)
        }
    }
    
    func presentOnMenuScreen(_ screen: AppCoordinatorScreen, isAnimated: Bool = true) {
        let targetVC = takeViewController(screen)
        let menuVC = sideMenuController?.menuViewController
        menuVC?.present(targetVC, animated: isAnimated, completion: nil)
    }
    
    func canOpenUrl(url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    func openUrl(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension AppCoordinator {
    func takeViewController(_ screen: AppCoordinatorScreen) -> UIViewController {
        switch screen {
        case .topics:
            let vc = TopicsRouter(appCoordinator: self).takeViewController()
            return vc
        case .question:
            let vc = QuestionRouter(appCoordinator: self).takeViewController()
            return vc
        case .topic(let topicId, let topicTitle):
            let vc = TopicRouter(appCoordinator: self).takeViewController(topicId: topicId, topicTitle: topicTitle)
            return vc
        case .menu:
            let vc = MenuRouter(appCoordinator: self).takeViewController()
            return vc
        case .settings:
            let vc = SettingsRouter(appCoordinator: self).takeViewController()
            return vc
        case .errorAlert(let message):
            let alert = ErrorAlertRouter(appCoordinator: self).takeViewController(message: message)
            return alert
        case .sendEmail(let recipients, let message, let isHTML, let delegate):
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = delegate
            vc.setToRecipients(recipients)
            vc.setMessageBody(message, isHTML: isHTML)
            return vc
        }
    }
}
