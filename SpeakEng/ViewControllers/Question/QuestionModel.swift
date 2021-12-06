//
//  QuestionModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 05.12.2021.
//

import Foundation

struct QuestionModel {
    struct Question {
        let questionId: Int
        let title: String
        let sort: Int
        let topicId: Int
    }
    
    struct Topic {
        let id: Int
        let title: String
    }
}
