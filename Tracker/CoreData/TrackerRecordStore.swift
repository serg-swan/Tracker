//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Сергей Лебедь on 23.08.2025.
//

import Foundation
import CoreData

public final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func addTrackerRecord(tracker: TrackerCoreData, date: Date) throws  {
        let trackerCoreDataRecord = TrackerCoreDataRecord(context: context)
        trackerCoreDataRecord.date = date
        trackerCoreDataRecord.tracker = tracker
     
        CoreDataManager.shared.saveContext()
    }
    
    func deleteOrAddTrackerRecord(tracker: TrackerCoreData, date: Date) throws  {
        let fetchRequest: NSFetchRequest<TrackerCoreDataRecord> = TrackerCoreDataRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "date == %@ AND tracker == %@",
            date as NSDate,
            tracker
            )
        
        guard let record = try context.fetch(fetchRequest).first else {
            
       return      try addTrackerRecord(tracker: tracker, date: date)
        }
        record.tracker = nil
        context.delete(record)
        CoreDataManager.shared.saveContext()
    }
    
    
}

