//
//  Constants.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 19.11.2021.
//

import UIKit

struct Constants {
    static let isDEBUG = false
    
    struct Server {
        static let url = "https://ojexsoft.com/"
        static let api = url + "porfolioapp/speakeng/"
    }
    
    struct Scalable {
        static let basicScreenWidth: CGFloat = 375.0
        static let basicIpadScreenWidth: CGFloat = 430.0
    }

    struct AppStore {
        static let appId = ""
    }
    
    struct SendEmail {
        static let email = ""
        static let message = ""
        static let isHTML = true
    }
}
