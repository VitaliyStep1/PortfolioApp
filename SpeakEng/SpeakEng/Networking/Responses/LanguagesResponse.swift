//
//  LanguagesResponse.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 23.11.2021.
//

import Foundation

struct LanguagesResponse: Codable {
    let id: Int
    let name: String
    let sort: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sort
    }
    
}

extension LanguagesResponse {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let id = Int(try values.decode(String.self, forKey: .id)) {
            self.id = id
        }
        else {
            throw NetworkingOptionalError.optionalNotAllowed
        }
        name = try values.decode(String.self, forKey: .name)
        if let sort = Int(try values.decode(String.self, forKey: .sort)) {
            self.sort = sort
        }
        else {
            throw NetworkingOptionalError.optionalNotAllowed
        }
    }
}

//extension Coordinate: Decodable {
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        latitude = try values.decode(Double.self, forKey: .latitude)
//        longitude = try values.decode(Double.self, forKey: .longitude)
//
//        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
//        elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
//    }
//}
