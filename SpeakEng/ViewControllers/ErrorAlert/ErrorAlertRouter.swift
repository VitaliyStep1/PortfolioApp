//
//  ErrorAlertRouter.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 21.11.2021.
//

import UIKit

class ErrorAlertRouter {
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func takeViewController(message: String) -> UIViewController {
        let title = "Error".localized()
        let okTitle = "Ok".localized()
        let alertC = ErrorAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: nil)
        alertC.addAction(okAction)
        alertC.router = self
        return alertC
    }
}
