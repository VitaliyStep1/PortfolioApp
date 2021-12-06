//
//  QuestionViewController.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import UIKit
import Combine

class QuestionViewController: BaseViewController {
    var viewModel: QuestionViewModel!
    private var subscriptions = Set<AnyCancellable>()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var translationView: QuestionTranslationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    private func bind() {
        viewModel.$question.sink { [weak self] question in
            self?.questionLabel.text = question?.title
        }.store(in: &subscriptions)
        
        viewModel.$translatedQuestion.sink { [weak self] translatedQuestion in
            self?.translationView.translatedLabel.text = translatedQuestion?.title
        }.store(in: &subscriptions)
        
        viewModel.$isTranslationVisible.sink { [weak self] isVisible in
            self?.translationView.translatedView.isHidden = !isVisible
            self?.translationView.showTranslationButton.isHidden = isVisible
        }.store(in: &subscriptions)
        
        viewModel.$topic.sink { [weak self] topic in
            self?.topicLabel.text = topic?.title
        }.store(in: &subscriptions)
    }
    
    private func setup() {
        titleLabel.text = "Question".localized()
        let nextQuestionTitle = "Next question".localized()
        nextQuestionButton.setTitle(nextQuestionTitle, for: .normal)
        let showTranslationTitle = "Show translation".localized()
        translationView.showTranslationButton.setTitle(showTranslationTitle, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppeared()
    }

    @IBAction func menuButtonClick() {
        viewModel.menuButtonClicked()
    }
    
    @IBAction func backButtonClick() {
        viewModel.backButtonClicked()
    }
    
    @IBAction func nextQuestionButtonClick() {
        viewModel.nextQuestionButtonClick()
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
