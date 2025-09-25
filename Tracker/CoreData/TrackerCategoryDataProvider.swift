//
//  TrackerCategoryDataProvider.swift
//  Tracker
//
//  Created by Сергей Лебедь on 13.09.2025.
//

import Foundation
import CoreData

final class TrackerCategoryDataProvider: NSObject {
    private let context: NSManagedObjectContext
    private let trackerCategoryStore: TrackerCategoryStore
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context,
    trackerCategoryStore: TrackerCategoryStore = CoreDataManager.shared.trackerCategoryStore) {
        self.context = context
        self.trackerCategoryStore = trackerCategoryStore
    }
    var onCategoriesDidChange: (() -> Void)?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreDataCategory> = {
        
        let fetchRequest: NSFetchRequest<TrackerCoreDataCategory> = TrackerCoreDataCategory.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCoreDataCategory.categoryName), ascending: true)]
        
        let fetchedResultsController =  NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
       return fetchedResultsController
    }()
    
    func fetchedObjects() -> Int {
       fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func object(at indexPath: IndexPath) -> String? {
      let categoryCoreData = fetchedResultsController.object(at: indexPath)
        return categoryCoreData.categoryName
    }
    func createNewCategory(withName name: String) throws {
       try? trackerCategoryStore.createTrackerCategory(category: name)
    }
    func deleteCategory(indexPath: IndexPath) throws {
        let categoryCoreData = fetchedResultsController.object(at: indexPath)
       try? trackerCategoryStore.deleteTrackerCategory(at: categoryCoreData)
       
    }
    func updateCategory(indexPath: IndexPath, newName: String) throws {
        let categoryCoreData = fetchedResultsController.object(at: indexPath)
        try? trackerCategoryStore.updateTrackerCategories(category: categoryCoreData, newName: newName)
    }
}
extension TrackerCategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onCategoriesDidChange?()
    }
    
  
}
