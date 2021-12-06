//
//  CoreDataStack.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 01.12.2021.
//

import Foundation
import CoreData

protocol CoreDataStackInterface {
    var persistentContainer: NSPersistentContainer? { get set }
    func saveContext() -> Bool
}

class CoreDataStack: CoreDataStackInterface {
    lazy var persistentContainer: NSPersistentContainer? = {
        let container = NSPersistentContainer(name: "SpeakEng")
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                self?.persistentContainer = nil
            }
        })
        return container
    }()

    func saveContext() -> Bool {
        let context = persistentContainer?.viewContext
        if context?.hasChanges ?? false {
            do {
                try context?.save()
            } catch {
                return false
            }
        }
        return true
    }
    
    deinit {
        _ = saveContext()
    }
}
