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
    
    func deleteTracker (tracker: TrackerCoreData) throws {
        context.delete(tracker)
        CoreDataManager.shared.saveContext()
    }
    
}
