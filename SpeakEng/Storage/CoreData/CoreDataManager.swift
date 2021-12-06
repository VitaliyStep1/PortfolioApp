//
//  CoreDataManager.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 01.12.2021.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let coreDataStack: CoreDataStackInterface = CoreDataStack()
    var MOC: NSManagedObjectContext? {
        return coreDataStack.persistentContainer?.viewContext
    }
    fileprivate init() {}
    
}
