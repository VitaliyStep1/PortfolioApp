//
//  QuestionsCoreDataManager.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 05.12.2021.
//

import Foundation
import CoreData

class QuestionsCoreDataManager {
    static let shared = QuestionsCoreDataManager()
    
    let coreDataStack: CoreDataStackInterface = CoreDataStack()
    var MOC: NSManagedObjectContext? {
        return coreDataStack.persistentContainer?.viewContext
    }
    fileprivate init() {}
    
    func addQuestions(questions: [Question]) -> IsSuccess {
        var questionsDict: [Int: [Question]] = [:]
        for question in questions {
            var array = questionsDict[question.languageId] ?? []
            array.append(question)
            questionsDict[question.languageId] = array
        }
        var isSuccess = true
        for languageId in questionsDict.keys {
            if let questions = questionsDict[languageId] {
                let isSuccess1 = addQuestions(questions: questions, languageId: languageId)
                isSuccess = isSuccess && isSuccess1
            }
        }
        return isSuccess
    }
    
    func addQuestions(questions: [Question], languageId: Int) -> IsSuccess {
        guard let MOC = self.MOC else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionCD")
        fetchRequest.predicate = NSPredicate(format: "languageId == %i", languageId)
        fetchRequest.returnsObjectsAsFaults = false
        
        let questionCDs = try? MOC.fetch(fetchRequest) as? [QuestionCD]
        var questionCDsDict: [Int: QuestionCD] = [:]
        if questionCDs != nil {
            for questionCD in questionCDs! {
                questionCDsDict[Int(questionCD.questionId)] = questionCD
            }
        }
        
        
        let entity = NSEntityDescription.entity(forEntityName: "QuestionCD", in: MOC)
        guard entity != nil else {
            return false
        }
        for question in questions {
            var questionCD: QuestionCD?
            if questionCDsDict[question.questionId] != nil {
                questionCD = questionCDsDict[question.questionId]
            }
            else {
                questionCD = QuestionCD(entity: entity!, insertInto: MOC)
                questionCD?.isUsed = false
            }
            
            questionCD?.questionId = Int32(question.questionId)
            questionCD?.topicId = Int16(question.topicId)
            questionCD?.title = question.title
            questionCD?.languageId = Int16(question.languageId)
            questionCD?.sort = Int32(question.sort)
            
        }
        do {
            try MOC.save()
        } catch {
            return false
        }
        return true
    }
    
    func takeRandomQuestion(languageId: Int) -> Question? {
        let question = takeRandomQuestion(languageId: languageId, isMakeIsUsedFalseIfNoNotUsedQuestions: true)
        return question
    }
    
    private func takeRandomQuestion(languageId: Int, isMakeIsUsedFalseIfNoNotUsedQuestions: Bool) -> Question? {
        guard let MOC = self.MOC else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionCD")
        fetchRequest.predicate = NSPredicate(format: "languageId == %i AND isUsed == %@", languageId, NSNumber(value: false))
        
        if let fetchRequestCount = try? MOC.count(for: fetchRequest) {
            if fetchRequestCount > 0 {
                fetchRequest.fetchOffset = Int.random(in: 0..<fetchRequestCount)
            }
        }
        
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let questionCDs = try MOC.fetch(fetchRequest) as? [QuestionCD]
            let questionCD = questionCDs?.first
            if questionCD != nil {
                let questionId = Int(questionCD!.questionId)
                let title = questionCD!.title ?? ""
                let sort = Int(questionCD!.sort)
                let topicId = Int(questionCD!.topicId)
                let languageId = Int(questionCD!.languageId)
                let question = Question(questionId: questionId, title: title, sort: sort, topicId: topicId, languageId: languageId)
                makeQuestionUsed(questionCD: questionCD!)
                return question
            }
            else {
                if isMakeIsUsedFalseIfNoNotUsedQuestions {
                    _ = makeQuestionsForLanguageNotUsed(languageId: languageId)
                    let question = takeRandomQuestion(languageId: languageId, isMakeIsUsedFalseIfNoNotUsedQuestions: false)
                    return question
                }
                else {
                    return nil
                }
            }
        }
        catch {
            return nil
        }
    }
    
    private func makeQuestionUsed(questionCD: QuestionCD) {
        questionCD.isUsed = true
        do {
            try MOC?.save()
        } catch {
            return
        }
    }
    
    private func makeQuestionsForLanguageNotUsed(languageId: Int) -> Bool {
        guard let MOC = self.MOC else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionCD")
        fetchRequest.predicate = NSPredicate(format: "languageId == %i", languageId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let questionCDs = try MOC.fetch(fetchRequest) as? [QuestionCD]
            if questionCDs != nil {
                for questionCD in questionCDs! {
                    questionCD.isUsed = false
                }
                do {
                    try MOC.save()
                } catch {
                    // true is ok here
                }
            }
            else {
                return false
            }
        }
        catch {
            return false
        }
        return true
    }
    
    func takeQuestion(questionId: Int, languageId: Int) -> Question? {
        guard let MOC = self.MOC else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionCD")
        fetchRequest.predicate = NSPredicate(format: "questionId == %i AND languageId == %i", questionId, languageId)
        
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let questionCDs = try MOC.fetch(fetchRequest) as? [QuestionCD]
            let questionCD = questionCDs?.first
            if questionCD != nil {
                let questionId = Int(questionCD!.questionId)
                let title = questionCD!.title ?? ""
                let sort = Int(questionCD!.sort)
                let topicId = Int(questionCD!.topicId)
                let languageId = Int(questionCD!.languageId)
                let question = Question(questionId: questionId, title: title, sort: sort, topicId: topicId, languageId: languageId)
                return question
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
    func takeQuestions(languageId: Int, topicId: Int) -> [Question]? {
        guard let MOC = self.MOC else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionCD")
        fetchRequest.predicate = NSPredicate(format: "languageId == %i AND topicId == %i", languageId, topicId)
        fetchRequest.returnsObjectsAsFaults = false
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let questionCDs = try MOC.fetch(fetchRequest) as? [QuestionCD]
            if questionCDs != nil {
                let questions = questionCDs!.map({ questionCD -> Question in
                    let questionId = Int(questionCD.questionId)
                    let title = questionCD.title ?? ""
                    let sort = Int(questionCD.sort)
                    let topicId = Int(questionCD.topicId)
                    let languageId = Int(questionCD.languageId)
                    let question = Question(questionId: questionId, title: title, sort: sort, topicId: topicId, languageId: languageId)
                    return question
                })
                return questions
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
}
