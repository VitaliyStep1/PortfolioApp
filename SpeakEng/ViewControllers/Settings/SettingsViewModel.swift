//
//  SettingsViewModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 17.11.2021.
//

import Foundation
import Combine
import PromiseKit

class SettingsViewModel {
    var router: SettingsRouter
    private var interfaceLanguages: [SettingsModel.InterfaceLanguage] = []
    var showInterfaceLanguagePickerViewSubject = PassthroughSubject<(languages: [SettingsModel.InterfaceLanguage], activeLanguageIndex: Int),Never>()
    var showTextLanguagePickerViewSubject = PassthroughSubject<(languages: [SettingsModel.TextLanguage], activeLanguageIndex: Int),Never>()
    var showTranslatesLanguagePickerViewSubject = PassthroughSubject<(languages: [SettingsModel.TextLanguage], activeLanguageIndex: Int),Never>()
    var reloadSettingsTableViewSubject = PassthroughSubject<Void,Never>()
    var interfaceLanguageChangedSubject = PassthroughSubject<Void,Never>()
    @Published private(set) var isShowLoadingIndicator = false
    
    let settingsItems: [SettingsModel.SettingsItem] = [
        .init(.interfaceLanguage, "", "Interface language"),
        .init(.textLanguage, "", "Text language"),
        .init(.translateLanguage, "", "Translates language"),
    ]
    
    let interfaceLanguageManager = InterfaceLanguageManager()
    let textLanguageManager = TextLanguageManager()
    let translatesLanguageManager = TranslatesLanguageManager()
    
    init(router: SettingsRouter) {
        self.router = router
    }
    
    func menuButtonClicked() {
        router.showMenu()
    }
    
    func viewDidLoaded() {
        
    }
}

extension SettingsViewModel {
    func takeCellsAmount() -> Int {
        let cellsAmount = settingsItems.count
        return cellsAmount
    }
    
    func takeCellInfo(row: Int) -> (cellType: SettingsModel.SettingsCellType, iconImageName: String, title: String) {
        let settingsItem = settingsItems[row]
        let cellType = settingsItem.cellType
        let iconImageName = settingsItem.imageName
        let title = settingsItem.title.localized()
        return (cellType: cellType, iconImageName: iconImageName, title: title)
    }
    
    func cellWasSelected(row: Int) {
        if settingsItems.indices.contains(row) {
            let settingsItem = settingsItems[row]
            let cellType = settingsItem.cellType
            switch cellType {
            case .interfaceLanguage:
                showInterfaceLanguageSelection()
            case .textLanguage:
                showTextLanguageSelection()
            case .translateLanguage:
                showTranslateLanguageSelection()
            }
        }
    }
    
    private func showInterfaceLanguageSelection() {
        let languages = interfaceLanguageManager.getAllInterfaceLanguages()
        let interfaceLanguages = languages.map({ interfaceLanguageEnum in
            SettingsModel.InterfaceLanguage(language: interfaceLanguageEnum, title: interfaceLanguageEnum.languageTitle)
        })
        let activeLanguage = interfaceLanguageManager.getActiveLanguage()
        var activeLanguageIndex = 0
        for (index, interfaceLanguage) in interfaceLanguages.enumerated() {
            let language = interfaceLanguage.language
            if language == activeLanguage {
                activeLanguageIndex = index
                break
            }
        }
        
        showInterfaceLanguagePickerViewSubject.send((languages: interfaceLanguages, activeLanguageIndex: activeLanguageIndex))
    }
    
    private func showTextLanguageSelection() {
        isShowLoadingIndicator = true
        firstly {
            DataService.getLanguages()
        }.done { [weak self] languages in
            let sortedLanguages = languages.sorted {
                $0.sort < $1.sort
            }
            let textLanguages = sortedLanguages.map { languagesResponse in
                SettingsModel.TextLanguage(id: languagesResponse.id, name: languagesResponse.name, title: languagesResponse.name)
            }
            let activeTextLanguageId = self?.textLanguageManager.getActiveLanguageId()
            var languageIndex = 0
            if activeTextLanguageId != nil {
                for (index, language) in textLanguages.enumerated() {
                    if language.id == activeTextLanguageId! {
                        languageIndex = index
                        break
                    }
                }
            }
            self?.showTextLanguagePickerViewSubject.send((languages: textLanguages, activeLanguageIndex: languageIndex))
        }.ensure { [weak self] in
            self?.isShowLoadingIndicator = false
        }.catch { [weak self] error in
            let errorMessage = "Some error happened.".localized() + " " + error.localizedDescription
            self?.router.showErrorAlert(message: errorMessage)
        }
    }
    
    private func showTranslateLanguageSelection() {
        isShowLoadingIndicator = true
        firstly {
            DataService.getLanguages()
        }.done { [weak self] languages in
            let sortedLanguages = languages.sorted {
                $0.sort < $1.sort
            }
            let textLanguages = sortedLanguages.map { languagesResponse in
                SettingsModel.TextLanguage(id: languagesResponse.id, name: languagesResponse.name, title: languagesResponse.name)
            }
            let activeTranslateLanguageId = self?.translatesLanguageManager.getActiveLanguageId()
            var languageIndex = 0
            if activeTranslateLanguageId != nil {
                for (index, language) in textLanguages.enumerated() {
                    if language.id == activeTranslateLanguageId! {
                        languageIndex = index
                        break
                    }
                }
            }
            self?.showTranslatesLanguagePickerViewSubject.send((languages: textLanguages, activeLanguageIndex: languageIndex))
        }.ensure { [weak self] in
            self?.isShowLoadingIndicator = false
        }.catch { [weak self] error in
            let errorMessage = "Some error happened.".localized() + " " + error.localizedDescription
            self?.router.showErrorAlert(message: errorMessage)
        }
    }
    
    func interfaceLanguageWasSelected(language: SettingsModel.InterfaceLanguage) {
        interfaceLanguageManager.saveActiveLanguage(language: language.language)
        reloadSettingsTableViewSubject.send()
        interfaceLanguageChangedSubject.send()
    }
    
    func textLanguageWasSelected(language: SettingsModel.TextLanguage) {
        textLanguageManager.changeActiveLanguageId(languageId: language.id)
        reloadSettingsTableViewSubject.send()
    }
    
    func translatesLanguageWasSelected(language: SettingsModel.TextLanguage) {
        translatesLanguageManager.saveActiveLanguageId(languageId: language.id)
        reloadSettingsTableViewSubject.send()
    }
}
