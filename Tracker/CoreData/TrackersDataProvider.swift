//
//  TrackersDataProvider.swift
//  Tracker
//
//  Created by Сергей Лебедь on 05.09.2025.
//

import Foundation
import CoreData

// MARK: - Delegate
protocol TrackersDataProviderDelegate: AnyObject {
    func didUpdateTrackersCollection()
}

// MARK: - Protocol
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

// MARK: - TrackersDataProvider
final class TrackersDataProvider: NSObject {
    
    // MARK: - Public properties
    weak var delegate: TrackersDataProviderDelegate?
    var onTrackersDidChange: (() -> Void)?
    
    // MARK: - Private properties
    private var weekDay: WeekDay? = nil
    private let context: NSManagedObjectContext
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    
    // MARK: - Init
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
    
    // MARK: - FetchedResultsController
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

// MARK: - TrackersDataProviderProtocol
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
         do {
             try trackerCategoryStore.fetchOrCreateCategory(tracker: tracker, category: category)
         } catch {
             print("Failed to fetch or create category: \(error)")
             throw error
         }
    }
    
    func addOrDeleteTrackerRecord(tracker: TrackerCoreData, date: Date) throws {
        fetchedResultsController.delegate = nil
        do {
            try  trackerRecordStore.deleteOrAddTrackerRecord(tracker: tracker, date: date)
            fetchedResultsController.delegate = self
        } catch {
            print("Failed to add or delete tracker record: \(error)")
            fetchedResultsController.delegate = self
            throw error
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackersCollection()
    }

}
