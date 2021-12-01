//
//  DataTarget.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 23.11.2021.
//

import Foundation
import Moya

enum DataTarget {
    case languages
    case topics(languageId: Int)
    case questions(mainLanguageId: Int, translationLanguageId: Int)
}

extension DataTarget: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Server.api)!
    }
    
    var path: String {
        switch self {
        case .languages:
            return "getLanguages.php"
        case .topics:
            return "getTopics.php"
        case .questions:
            return "getQuestions.php"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .languages:
            return .requestPlain
        case .topics(let languageId):
            return .requestParameters(parameters: ["languageId": languageId], encoding: URLEncoding.queryString)
        case .questions(let mainLanguageId, let translationLanguageId):
            return .requestParameters(parameters: ["languageId1": mainLanguageId, "languageId2": translationLanguageId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
