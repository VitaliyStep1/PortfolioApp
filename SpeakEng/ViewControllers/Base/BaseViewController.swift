//
//  BaseViewController.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 29.11.2021.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
//        let menuTitle = "Menu".localized()
//        menuButton.setTitle(menuTitle, for: .normal)
    }
}
