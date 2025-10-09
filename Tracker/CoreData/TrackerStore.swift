//
//  TrackerStore.swift
//  Tracker
//
//  Created by Сергей Лебедь on 23.08.2025.
//

import Foundation
import CoreData

public final class TrackerStore {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
        func createTracker (tracker: Tracker, category: TrackerCoreDataCategory) throws {
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.color = tracker.color
            trackerCoreData.timeTable = tracker.timeTable as NSObject
            trackerCoreData.trackerCategory = category
    
            CoreDataManager.shared.saveContext()
        }
    
    func editTracker (tracker: TrackerCoreData, editTracker: Tracker, categoryCoreData: TrackerCoreDataCategory) throws {
        let trackerCoreData = tracker
        trackerCoreData.name = editTracker.name
        trackerCoreData.emoji = editTracker.emoji
        trackerCoreData.color = editTracker.color
        trackerCoreData.timeTable = editTracker.timeTable as NSObject
        trackerCoreData.trackerCategory = categoryCoreData
        
        CoreDataManager.shared.saveContext()
    }
    func trackersStoreNotIsEmpty() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        fetchRequest.fetchLimit = 1
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Ошибка при проверке наличия данных: \(error)")
            return false
        }
    }
    
    func deleteTracker (tracker: TrackerCoreData) throws {
        context.delete(tracker)
        CoreDataManager.shared.saveContext()
    }
    
}
