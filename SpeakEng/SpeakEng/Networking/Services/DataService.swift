//
//  DataService.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 24.11.2021.
//

import Foundation
import Moya
import PromiseKit

class DataService {
    static let provider = MoyaProvider<DataTarget>(plugins: [VerbosePlugin(verbose: true)])
    
    static func getLanguages() -> Promise<[LanguagesResponse]> {
        return Promise<[LanguagesResponse]> { seal in
            provider.request(.languages) { result in
                switch result {
                case let .success(moyaResponse):
                    let decoder = JSONDecoder()
                    do {
                        let objects = try decoder.decode([LanguagesResponse].self, from: moyaResponse.data)
                        seal.fulfill(objects)
                    } catch {
                        seal.reject(error)
                    }
                    
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    static func getTopics(languageId: Int) -> Promise<[TopicsResponse]> {
        return Promise<[TopicsResponse]> { seal in
            provider.request(.topics(languageId: languageId)) { result in
                switch result {
                case let .success(moyaResponse):
                    let decoder = JSONDecoder()
                    do {
                        let objects = try decoder.decode([TopicsResponse].self, from: moyaResponse.data)
                        seal.fulfill(objects)
                    } catch {
                        seal.reject(error)
                    }
                    
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    static func getQuestions(mainLanguageId: Int, translationLanguageId: Int) -> Promise<QuestionsResponse> {
        return Promise<QuestionsResponse> { seal in
            provider.request(.questions(mainLanguageId: mainLanguageId, translationLanguageId: translationLanguageId)) { result in
                switch result {
                case let .success(moyaResponse):
                    let decoder = JSONDecoder()
                    do {
                        let objects = try decoder.decode(QuestionsResponse.self, from: moyaResponse.data)
                        seal.fulfill(objects)
                    } catch {
                        seal.reject(error)
                    }
                    
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
}
