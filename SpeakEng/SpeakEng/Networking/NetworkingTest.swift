//
//  NetworkingTest.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 24.11.2021.
//

import Foundation
import PromiseKit

class NetworkingTest {
    static let shared = NetworkingTest()
    
    fileprivate init() {}
    
    func test() {
        firstly {
            DataService.getLanguages()
        }
        .done { languages in
            print("test getLanguages")
            print(languages)
        }.catch { error in
            print("test getLanguages error")
            print(error.localizedDescription)
        }
        
        firstly {
            DataService.getTopics(languageId: 1)
        }
        .done { topics in
            print("test getTopics")
            print(topics)
        }.catch { error in
            print("test getTopics error")
            print(error.localizedDescription)
        }
        
        firstly {
            DataService.getQuestions(mainLanguageId: 1, translationLanguageId: 2)
        }
        .done { questions in
            print("test getQuestions")
            print(questions)
        }.catch { error in
            print("test getQuestions error")
            print(error.localizedDescription)
        }
    }
}
