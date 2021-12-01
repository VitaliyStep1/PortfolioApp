//
//  TranslationView.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 20.11.2021.
//

import UIKit

class TranslationView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var translatedLabel: UILabel!
    @IBOutlet weak var translatedView: UIView!
    @IBOutlet weak var  showTranslationButton: UIButton!
    
    var onLanguageButtonClicked: (()->Void)?
    var onShowTranslationButtonClicked: (()->Void)?
    var onHideTranslationButtonClicked: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    private func initSubViews() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    @IBAction func showTranslationButtonClick() {
        
        onShowTranslationButtonClicked?()
    }
    
    @IBAction func hideTranslationButtonClick() {
        onHideTranslationButtonClicked?()
    }
    
    @IBAction func languageButtonClick() {
        onLanguageButtonClicked?()
    }
}
