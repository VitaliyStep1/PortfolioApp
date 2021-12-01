//
//  TopicsModel.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 19.11.2021.
//

import Foundation

struct TopicsModel {
    enum SectionType {
        case randomQuestion
        case randomTopic
        case topic
    }
    
    struct Topic {
        let id: Int
        let title: String
    }
}
