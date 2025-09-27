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
        super.init( )
        self.performFetch()
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
       return fetchedResultsController
    }()
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("❌ Ошибка fetch категорий: \(error)")
        }
    }
    
    func fetchedObjects() -> Int {
       fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func object(at indexPath: IndexPath) -> String? {
      let categoryCoreData = fetchedResultsController.object(at: indexPath)
        return categoryCoreData.categoryName
    }
    func createNewCategory(withName name: String) throws {
        do {
               try trackerCategoryStore.createTrackerCategory(category: name)
           } catch {
               print("❌ Ошибка при создании категории: \(error)")
               throw error
           }
       
    }
    func deleteCategory(indexPath: IndexPath) throws {
        let categoryCoreData = fetchedResultsController.object(at: indexPath)
        do {
            try trackerCategoryStore.deleteTrackerCategory(at: categoryCoreData)
           } catch {
               print("❌ Ошибка при удалении категории: \(error)")
               throw error
           }
       
    }
    func updateCategory(indexPath: IndexPath, newName: String) throws {
        let categoryCoreData = fetchedResultsController.object(at: indexPath)
        do{
            try trackerCategoryStore.updateTrackerCategories(category: categoryCoreData, newName: newName)
        } catch {
            print("❌ Ошибка при обновлении категории: \(error)")
            throw error
        }
    }
}
extension TrackerCategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onCategoriesDidChange?()
    }
    
  
}
