//
//  MenuViewModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import Foundation
import Combine

class MenuViewModel {
    var router: MenuRouter
    
    var reloadItemsTableViewSubject = PassthroughSubject<Void,Never>()
    
    let menuItems: [MenuModel.MenuItem] = [
        .init(.topics, "", "Topics"),
        .init(.settings, "", "Settings"),
        .init(.sendEmail, "", "Send email"),
        .init(.review, "", "Review"),
    ]
    
    init(router: MenuRouter) {
        self.router = router
    }
    
    func viewWillAppeared() {
        reloadItemsTableViewSubject.send()
    }
}

extension MenuViewModel {
    func takeRowsAmount() -> Int {
        let rowsAmount = menuItems.count
        return rowsAmount
    }
    
    func takeCellInfo(row: Int) -> (cellType: MenuModel.MenuCellType, iconImageName: String, title: String) {
        let menuItem = menuItems[row]
        let cellType = menuItem.cellType
        let iconImageName = menuItem.imageName
        let title = menuItem.title.localized()
        return (cellType: cellType, iconImageName: iconImageName, title: title)
    }
    
    func cellWasSelected(row: Int) {
        let menuItem = menuItems[row]
        switch menuItem.cellType {
        case .topics:
            router.showTopicsScreen()
        case .settings:
            router.showSettingsScreen()
        case .sendEmail:
            sendEmail()
        case .review:
            sendReview()
        }
    }
    
    private func sendEmail() {
        let recipients = [Constants.SendEmail.email]
        let emailMessage = Constants.SendEmail.message
        let isHTML = Constants.SendEmail.isHTML
        let errorMessage = "Sending email failed".localized()
        router.showSendEmailScreenOrErrorAlert(recipients: recipients, message: emailMessage, isHTML: isHTML, errorMessage: errorMessage)
    }
    
    private func sendReview() {
        let appId = Constants.AppStore.appId
        let urlString =  "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + appId;
        if let url = URL(string: urlString) {
            let errorMessage = "Sending review failed".localized()
            router.openUrlOrSendErrorAlert(url: url, errorMessage: errorMessage)
        }
        else {
            let errorMessage = "Sending review failed".localized()
            router.showErrorAlert(message: errorMessage)
        }
    }
}
