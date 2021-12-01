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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    func bind() {
        viewModel.$topicTitle.sink { [weak self] topicTitle in
            self?.titleLabel.text = topicTitle
        }.store(in: &subscriptions)
    }
    
    @IBAction func menuButtonClick() {
        viewModel.menuButtonClicked()
    }
    
    @IBAction func backButtonClick() {
        viewModel.backButtonClicked()
    }
}
