//
//  TopicsResponse.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 23.11.2021.
//

import Foundation

struct TopicsResponse: Codable {
    let id: Int
    let sort: Int
    let languageId: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sort
        case languageId
        case title
    }
}

extension TopicsResponse {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let id = Int(try values.decode(String.self, forKey: .id)) {
            self.id = id
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
