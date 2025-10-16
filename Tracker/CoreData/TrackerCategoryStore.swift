//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Сергей Лебедь on 23.08.2025.
//

import Foundation
import CoreData

public final class TrackerCategoryStore {
    var updatePredicate: (() -> Void)?
    private let context: NSManagedObjectContext
    let trackerStore: TrackerStore
    init(context: NSManagedObjectContext = CoreDataManager.shared.context,
         trackerStore: TrackerStore = CoreDataManager.shared.trackerStore) {
        self.context = context
        self.trackerStore = trackerStore
    }
    
    func findCategoryName(_ name: String) throws -> TrackerCoreDataCategory? {
        let fetchRequest: NSFetchRequest<TrackerCoreDataCategory> = TrackerCoreDataCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreDataCategory.categoryName),
            name
        )
        guard let category = try context.fetch(fetchRequest).first else {
            return nil
        }
        return category
    }
    
    func createTrackerCategory (category: String) throws {
        let trackerCategoryCoreData = TrackerCoreDataCategory(context: context)
        trackerCategoryCoreData.categoryName = category
        CoreDataManager.shared.saveContext()
    }
    
    func  deleteTrackerCategory(at categoryCoreData: TrackerCoreDataCategory) throws {
        context.delete(categoryCoreData)
        CoreDataManager.shared.saveContext()
        
    }
    func updateTrackerCategories(category: TrackerCoreDataCategory, newName: String) throws {
        category.categoryName = newName
        CoreDataManager.shared.saveContext()
        updatePredicate?()
    }
    
}
