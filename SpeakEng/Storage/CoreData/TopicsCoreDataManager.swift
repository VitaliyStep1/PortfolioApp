//
//  TopicsCoreDataManager.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 05.12.2021.
//

import Foundation
import CoreData

typealias IsSuccess = Bool

class TopicsCoreDataManager {
    static let shared = TopicsCoreDataManager()
    
    let coreDataStack: CoreDataStackInterface = CoreDataStack()
    var MOC: NSManagedObjectContext? {
        return coreDataStack.persistentContainer?.viewContext
    }
    fileprivate init() {}
    
    func addTopics(topics: [Topic]) -> IsSuccess {
        var topicsDict: [Int: [Topic]] = [:]
        for topic in topics {
            var array = topicsDict[topic.languageId] ?? []
            array.append(topic)
            topicsDict[topic.languageId] = array
        }
        var isSuccess = true
        for languageId in topicsDict.keys {
            if let topics = topicsDict[languageId] {
                let isSuccess1 = addTopics(topics: topics, languageId: languageId)
                isSuccess = isSuccess && isSuccess1
            }
        }
        return isSuccess
    }
    
    private func addTopics(topics: [Topic], languageId: Int) -> IsSuccess {
        guard let MOC = self.MOC else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TopicCD")
        fetchRequest.predicate = NSPredicate(format: "languageId == %i", languageId)
        fetchRequest.returnsObjectsAsFaults = false
        
        let topicCDs = try? MOC.fetch(fetchRequest) as? [TopicCD]
        var topicCDDict: [Int: TopicCD] = [:]
        if topicCDs != nil {
            for topicCD in topicCDs! {
                topicCDDict[Int(topicCD.topicId)] = topicCD
            }
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "TopicCD", in: MOC)
        guard entity != nil else {
            return false
        }
        for topic in topics {
            var topicCD: TopicCD?
            if topicCDDict[topic.topicId] != nil {
                topicCD = topicCDDict[topic.topicId]
            }
            else {
                topicCD = TopicCD(entity: entity!, insertInto: MOC)
            }
            topicCD?.topicId = Int16(topic.topicId)
            topicCD?.title = topic.title
            topicCD?.languageId = Int16(topic.languageId)
            topicCD?.sort = Int16(topic.sort)
        }
        do {
            try MOC.save()
        } catch {
            return false
        }
        return true
    }
    
    func takeRandomTopic(languageId: Int) -> Topic? {
        guard let MOC = self.MOC else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TopicCD")
        fetchRequest.predicate = NSPredicate(format: "languageId == %i", languageId)
        
        if let fetchRequestCount = try? MOC.count(for: fetchRequest) {
            fetchRequest.fetchOffset = Int.random(in: 0...fetchRequestCount)
        }
        
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let topicCDs = try MOC.fetch(fetchRequest) as? [TopicCD]
            let topicCD = topicCDs?.first
            if topicCD != nil {
                let topicId = Int(topicCD!.topicId)
                let title = topicCD!.title ?? ""
                let sort = Int(topicCD!.sort)
                let languageId = Int(topicCD!.languageId)
                let topic = Topic(topicId: topicId, title: title, sort: sort, languageId: languageId)
                return topic
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
    func takeAllTopics(languageId: Int) -> [Topic]? {
        guard let MOC = self.MOC else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TopicCD")
        fetchRequest.predicate = NSPredicate(format: "languageId == %i", languageId)
        fetchRequest.returnsObjectsAsFaults = false
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let topicCDs = try MOC.fetch(fetchRequest) as? [TopicCD]
            if topicCDs != nil {
                let topics = topicCDs!.map { topicCD -> Topic in
                    let topicId = Int(topicCD.topicId)
                    let title = topicCD.title ?? ""
                    let sort = Int(topicCD.sort)
                    let languageId = Int(topicCD.languageId)
                    let topic = Topic(topicId: topicId, title: title, sort: sort, languageId: languageId)
                    return topic
                }
                return topics
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
    func takeTopic(languageId: Int, topicId: Int) -> Topic? {
        guard let MOC = self.MOC else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TopicCD")
        fetchRequest.predicate = NSPredicate(format: "languageId == %i AND topicId == %i", languageId, topicId)
        
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let topicCDs = try MOC.fetch(fetchRequest) as? [TopicCD]
            let topicCD = topicCDs?.first
            if topicCD != nil {
                let topicId = Int(topicCD!.topicId)
                let title = topicCD!.title ?? ""
                let sort = Int(topicCD!.sort)
                let languageId = Int(topicCD!.languageId)
                let topic = Topic(topicId: topicId, title: title, sort: sort, languageId: languageId)
                return topic
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
