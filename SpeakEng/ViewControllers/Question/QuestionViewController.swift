//
//  QuestionViewController.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 09.11.2021.
//

import UIKit

class QuestionViewController: BaseViewController {
    var viewModel: QuestionViewModel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Question".localized()
    }

    @IBAction func menuButtonClick() {
        viewModel.menuButtonClicked()
    }
    
    @IBAction func backButtonClick() {
        viewModel.backButtonClicked()
    }
}
