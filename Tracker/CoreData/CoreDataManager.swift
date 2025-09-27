//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.08.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
   
      lazy var trackerCategoryStore: TrackerCategoryStore = {
          TrackerCategoryStore(context: self.context)
      }()
    lazy var trackerRecordStore: TrackerRecordStore = {
           TrackerRecordStore(context: self.context)
       }()
    lazy var trackerStore: TrackerStore = {
        TrackerStore(context: self.context)
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure(error.localizedDescription)
            }
        })
            return container
        }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("❌ Ошибка сохранения контекста: \(error)")
                          print("❌ Подробности: \((error as NSError).userInfo)")
            }
        }
    }
}
