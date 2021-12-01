//
//  QuestionsResponse.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 23.11.2021.
//

import Foundation

struct QuestionsResponse: Codable {
    
    let questions1: [Question]
    let questions2: [Question]
    
    enum CodingKeys: String, CodingKey {
        case questions1
        case questions2
    }
    
    struct Question: Codable {
        let id: Int?
        let topicId: Int?
        let sort: Int?
        let languageId: Int?
        let title: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case topicId
            case sort
            case languageId
            case title
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            if let id = Int(try values.decode(String.self, forKey: .id)) {
                self.id = id
            }
            else {
                throw NetworkingOptionalError.optionalNotAllowed
            }
            
            if let topicId = Int(try values.decode(String.self, forKey: .topicId)) {
                self.topicId = topicId
            }
            else {
                throw NetworkingOptionalError.optionalNotAllowed
            }
            
            if let sort = Int(try values.decode(String.self, forKey: .sort)) {
                self.sort = sort
            }
            else {
                throw NetworkingOptionalError.optionalNotAllowed
            }
            
            if let languageId = Int(try values.decode(String.self, forKey: .languageId)) {
                self.languageId = languageId
            }
            else {
                throw NetworkingOptionalError.optionalNotAllowed
            }
            
            title = try values.decode(String.self, forKey: .title)
        }
    }
}
    
extension QuestionsResponse {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        questions1 = try values.decode([Question].self, forKey: .questions1)
        questions2 = try values.decode([Question].self, forKey: .questions2)
    }
}
