//
//  TrackersDataProvider.swift
//  Tracker
//
//  Created by Сергей Лебедь on 05.09.2025.
//

import Foundation
import CoreData

protocol TrackersDataProviderDelegate: AnyObject {
    func didUpdateTrackersCollection()
}

protocol TrackersDataProviderProtocol {
    var delegate: TrackersDataProviderDelegate? { get set }
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func trackerObject(at indexPath: IndexPath) -> TrackerCoreData?
    func categoryObject(at indexPath: IndexPath) -> String?
    func updateFilter(for day: WeekDay)
    func fetchOrCreateCategory(tracker: Tracker, category: String) throws
    func addOrDeleteTrackerRecord(tracker: TrackerCoreData, date: Date) throws
}

final class TrackersDataProvider: NSObject {
    
    weak var delegate: TrackersDataProviderDelegate?
    
    
    var onTrackersDidChange: (() -> Void)?
    private var weekDay: WeekDay? = nil
    private let context: NSManagedObjectContext
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    init(context: NSManagedObjectContext = CoreDataManager.shared.context,
         trackerCategoryStore: TrackerCategoryStore = CoreDataManager.shared.trackerCategoryStore,
         trackerRecordStore: TrackerRecordStore = CoreDataManager.shared.trackerRecordStore) {
        self.context = context
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        super .init()
        trackerCategoryStore.updatePredicate = { [weak self] in
            self?.updateFilter(for: self?.weekDay ?? .friday)
        }
    }
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCoreData.trackerCategory.categoryName), ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: "trackerCategory.categoryName",
                                                                  cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
        
}

extension TrackersDataProvider: TrackersDataProviderProtocol {
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func trackerObject(at indexPath: IndexPath) -> TrackerCoreData? {
        fetchedResultsController.object(at: indexPath)
    }
    
    func categoryObject(at indexPath: IndexPath) -> String? {
        let  category = fetchedResultsController.sections?[indexPath.section]
        return category?.name
    }
    
    func updateFilter(for day: WeekDay) {
        weekDay = day
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "timeTable CONTAINS %@",
            day.rawValue
        )
        
        try? fetchedResultsController.performFetch()
        delegate?.didUpdateTrackersCollection()
    }
    
    func fetchOrCreateCategory(tracker: Tracker, category: String) throws  {
        try? trackerCategoryStore.fetchOrCreateCategory(tracker: tracker, category: category)
    }
    
    func addOrDeleteTrackerRecord(tracker: TrackerCoreData, date: Date) throws {
        fetchedResultsController.delegate = nil
        try?  trackerRecordStore.deleteOrAddTrackerRecord(tracker: tracker, date: date)
        fetchedResultsController.delegate = self
    }
}

extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackersCollection()
    }
    
}


