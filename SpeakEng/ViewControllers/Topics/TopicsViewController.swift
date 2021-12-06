//
//  TopicsViewController.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import UIKit
import Combine

class TopicsViewController: BaseViewController {
    var viewModel: TopicsViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var topicsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        viewModel.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppeared()
    }
    
    private func bind() {
        viewModel.$isShowLoadingIndicator.sink { [weak self] isShow in
            if isShow {
                self?.showLoadingIndicator()
            }
            else {
                self?.hideLoadingIndicator()
            }
        }.store(in: &subscriptions)
        
        viewModel.topicsSubject.sink { [weak self] topics in
            self?.topicsTableView.reloadData()
        }.store(in: &subscriptions)
    }
    
    private func setup() {
        titleLabel?.text = "Topics".localized()
    }
    
    @IBAction func menuButtonClick() {
        viewModel.menuButtonClicked()
    }
}

extension TopicsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionsAmount = viewModel.takeSectionsAmount()
        return sectionsAmount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsAmount = viewModel.takeRowsAmount(section: section)
        return rowsAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = viewModel.takeCellInfo(section: indexPath.section, row: indexPath.row)
        var cellIdentifier = ""
        switch cellInfo.sectionType {
        case .randomQuestion:
            cellIdentifier = "TopicsRandomQuestionCellIdentifier"
        case .randomTopic:
            cellIdentifier = "TopicsRandomTopicCellIdentifier"
        case .topic:
            cellIdentifier = "TopicsTopicCellIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TopicsTableViewCell
        cell?.iconImageView.image = UIImage(named: cellInfo.imageName)
        cell?.titleLabel.text = cellInfo.title
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellWasSelected(section: indexPath.section, row: indexPath.row)
    }
}

extension TopicsViewController {
    func showLoadingIndicator() {
        loadingView.showLoading()
    }
    
    func hideLoadingIndicator() {
        loadingView.hideLoading()
    }
}
