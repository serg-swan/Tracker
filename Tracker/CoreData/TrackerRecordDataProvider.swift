//
//  TrackerRecordDataProvider.swift
//  Tracker
//
//  Created by Сергей Лебедь on 13.09.2025.
//

import Foundation
import CoreData

final class TrackerRecordDataProvider: NSObject {
    private let context: NSManagedObjectContext
    private let trackerRecordStore: TrackerRecordStore
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context,
    trackerRecordStore: TrackerRecordStore = CoreDataManager.shared.trackerRecordStore) {
        self.context = context
        self.trackerRecordStore = trackerRecordStore
        super.init( )
        self.performFetch()
       
    }
    var onRecordDidChange: Binding<Int>?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreDataRecord> = {
        let fetchRequest: NSFetchRequest<TrackerCoreDataRecord> = TrackerCoreDataRecord.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCoreDataRecord.date), ascending: true)]
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
            print("❌ Ошибка fetch рекорда: \(error)")
        }
    }
    
    func fetchedObjects() -> Int {
       fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
}
extension TrackerRecordDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       onRecordDidChange?(fetchedObjects())
    }
      
}
