//
//  TopicViewController.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import UIKit
import Combine

class TopicViewController: BaseViewController {
    var viewModel: TopicViewModel!
    @IBOutlet weak var titleLabel: UILabel!
    private var subscriptions = Set<AnyCancellable>()
    @IBOutlet weak var translationView: TopicTranslationView!
    @IBOutlet weak var questionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppeared()
    }
    
    private func bind() {
        viewModel.$topicTitle.sink { [weak self] topicTitle in
            self?.titleLabel.text = topicTitle
        }.store(in: &subscriptions)
        
        viewModel.$translatedQuestion.sink { [weak self] translatedQuestion in
            self?.translationView.translatedLabel.text = translatedQuestion?.title
        }.store(in: &subscriptions)
        
        viewModel.$isTranslationVisible.sink { [weak self] isVisible in
            self?.translationView.translatedView.isHidden = !isVisible
            self?.translationView.showTranslationButton.isHidden = isVisible
        }.store(in: &subscriptions)
        
        viewModel.questionsSubject.sink { [weak self] _ in
            self?.questionsTableView.reloadData()
        }.store(in: &subscriptions)
        
        viewModel.selectedRowSubject.sink { [weak self] _ in
            self?.questionsTableView.reloadData()
        }.store(in: &subscriptions)
    }
    
    private func setup() {
        let showTranslationTitle = "Show translation".localized()
        translationView.showTranslationButton.setTitle(showTranslationTitle, for: .normal)
    }
    
    @IBAction func menuButtonClick() {
        viewModel.menuButtonClicked()
    }
    
    @IBAction func backButtonClick() {
        viewModel.backButtonClicked()
    }
    
    @IBAction func hideTranslationViewButtonClick() {
        viewModel.hideTranslationViewButtonClicked()
    }
    
    @IBAction func languageTranslationViewButtonClick() {
        viewModel.languageTranslationViewButtonClicked()
    }
    
    @IBAction func showTranslationViewButtonClick() {
        viewModel.showTranslationViewButtonClicked()
    }
}

extension TopicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsAmount = viewModel.takeRowsAmount(section: section)
        return rowsAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TopicQuestionCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TopicQuestionTableViewCell
        let cellInfo = viewModel.takeCellInfo(row: indexPath.row)
        cell.titleLabel.text = cellInfo.title
        if cellInfo.isSelected {
            cell.backgroundColor = .green
        }
        else {
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellWasSelected(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let baseCellHeight: CGFloat = 50
        let cellHeight = baseCellHeight * Scalable.scale
        return cellHeight
    }
}
