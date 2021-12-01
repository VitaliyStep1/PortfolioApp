//
//  SettingsViewController.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 17.11.2021.
//

import UIKit
import Combine

class SettingsViewController: BaseViewController {
    var viewModel: SettingsViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var toolBarPickerView: ToolBarPickerView!
    @IBOutlet weak var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    @IBAction func menuButtonClick() {
        viewModel.menuButtonClicked()
    }
    
    func setup() {
        toolBarPickerView.hide()
        loadingView.hideLoading()
        titleLabel.text = "Settings".localized()
    }
    
    func bind() {
        viewModel.showInterfaceLanguagePickerViewSubject.sink { [weak self] interfaceLanguagesInfo in
            let interfaceLanguages = interfaceLanguagesInfo.languages
            let activeLanguageIndex = interfaceLanguagesInfo.activeLanguageIndex
            self?.showInterfaceLanguagePickerView(languages: interfaceLanguages, activeLanguageIndex: activeLanguageIndex)
        }.store(in: &subscriptions)
        
        viewModel.showTextLanguagePickerViewSubject.sink { [weak self] languagesInfo in
            let languages = languagesInfo.languages
            let activeLanguageIndex = languagesInfo.activeLanguageIndex
            self?.showTextLanguagePickerView(languages: languages, activeLanguageIndex: activeLanguageIndex)
        }.store(in: &subscriptions)
        
        viewModel.showTranslatesLanguagePickerViewSubject.sink { [weak self] languagesInfo in
            let languages = languagesInfo.languages
            let activeLanguageIndex = languagesInfo.activeLanguageIndex
            self?.showTranslatesLanguagePickerView(languages: languages, activeLanguageIndex: activeLanguageIndex)
        }.store(in: &subscriptions)
        
        viewModel.reloadSettingsTableViewSubject.sink { [weak self] in
            self?.settingsTableView.reloadData()
        }.store(in: &subscriptions)
        
        viewModel.$isShowLoadingIndicator.sink { [weak self] isShow in
            if isShow {
                self?.showLoadingIndicator()
            }
            else {
                self?.hideLoadingIndicator()
            }
        }.store(in: &subscriptions)
    }
    
    func showInterfaceLanguagePickerView(languages: [SettingsModel.InterfaceLanguage], activeLanguageIndex: Int) {
        toolBarPickerView.show(items: languages, selectedIndex: activeLanguageIndex) { [weak self] language in
            self?.toolBarPickerView.hide()
            self?.viewModel.interfaceLanguageWasSelected(language: language as! SettingsModel.InterfaceLanguage)
        } cancelAction: { [weak self] in
            self?.toolBarPickerView.hide()
        }
    }
    
    func showTextLanguagePickerView(languages: [SettingsModel.TextLanguage], activeLanguageIndex: Int) {
        toolBarPickerView.show(items: languages, selectedIndex: activeLanguageIndex) { [weak self] language in
            self?.toolBarPickerView.hide()
            self?.viewModel.textLanguageWasSelected(language: language as! SettingsModel.TextLanguage)
        } cancelAction: { [weak self] in
            self?.toolBarPickerView.hide()
        }
    }
    
    func showTranslatesLanguagePickerView(languages: [SettingsModel.TextLanguage], activeLanguageIndex: Int) {
        toolBarPickerView.show(items: languages, selectedIndex: activeLanguageIndex) { [weak self] language in
            self?.toolBarPickerView.hide()
            self?.viewModel.translatesLanguageWasSelected(language: language as! SettingsModel.TextLanguage)
        } cancelAction: { [weak self] in
            self?.toolBarPickerView.hide()
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellsAmount = viewModel.takeCellsAmount()
        return cellsAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingsCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SettingsTableViewCell
        let cellInfo = viewModel.takeCellInfo(row: indexPath.row)
        cell.iconImageView.image = UIImage(named: cellInfo.iconImageName)
        cell.titleLabel.text = cellInfo.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let baseCellHeight: CGFloat = 60.0
        let cellHeight = baseCellHeight * Scalable.scale
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellWasSelected(row: indexPath.row)
    }
}

extension SettingsViewController {
    func showLoadingIndicator() {
        loadingView.showLoading()
        loadingView.isHidden = false
    }
    
    func hideLoadingIndicator() {
        loadingView.hideLoading()
        loadingView.isHidden = true
    }
}
