//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Сергей Лебедь on 23.08.2025.
//

import Foundation
import CoreData

public final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    let trackerStore: TrackerStore
    init(context: NSManagedObjectContext = CoreDataManager.shared.context ) {
        self.context = context
        self.trackerStore = TrackerStore(context: context)
    }
  
    
    func fetchOrCreateCategory(tracker: Tracker, category: String) throws {     
        let fetchRequest: NSFetchRequest<TrackerCoreDataCategory> = TrackerCoreDataCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate( format: "%K == %@",
                                              #keyPath(TrackerCoreDataCategory.categoryName),
                                              category)
        
        let targetCategory: TrackerCoreDataCategory
        
        if let existingCategory = try context.fetch(fetchRequest).first {
            targetCategory = existingCategory
        } else {
            let newCategory = TrackerCoreDataCategory(context: context)
            newCategory.categoryName = category
            targetCategory = newCategory
        }
        try trackerStore.createTracker(tracker: tracker, category: targetCategory)
    }
}

