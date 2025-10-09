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
    func updateFilter(selectedWeekDay: WeekDay, currentFilter: TrackerFilter, searchText: String?)
    func fetchCategory(tracker: Tracker) throws -> TrackerCoreDataCategory?
    func addOrDeleteTrackerRecord(tracker: TrackerCoreData, date: Date) throws
    func deleteTracker(_ indexPath: IndexPath) throws
    func editTracker(trackerCoreData: TrackerCoreData, trackerNewData: Tracker)throws
    func createTracker(tracker: Tracker) throws
    func trackersStoreNotIsEmpty() -> Bool
}

// MARK: - TrackersDataProvider
final class TrackersDataProvider: NSObject {
    
    // MARK: - Public properties
    weak var delegate: TrackersDataProviderDelegate?
    var onTrackersDidChange: (() -> Void)?
    
    // MARK: - Private properties
    private var currentFilter: TrackerFilter = .all
    private var weekDay: WeekDay
    private var searchText: String? = nil
    private let context: NSManagedObjectContext
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    private let trackerStore: TrackerStore
    
    // MARK: - Init
    init(context: NSManagedObjectContext = CoreDataManager.shared.context,
         trackerCategoryStore: TrackerCategoryStore = CoreDataManager.shared.trackerCategoryStore,
         trackerRecordStore: TrackerRecordStore = CoreDataManager.shared.trackerRecordStore,
         trackerStore:TrackerStore = CoreDataManager.shared.trackerStore) {
        self.context = context
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        self.trackerStore = trackerStore
        self.weekDay = .monday
        super .init()
        trackerCategoryStore.updatePredicate = { [weak self] in
            guard let self else { return }
            self.updateFilter(selectedWeekDay: self.weekDay, currentFilter: self.currentFilter, searchText: self.searchText)
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
    func updateFilter(selectedWeekDay: WeekDay, currentFilter: TrackerFilter, searchText: String? = nil) {
        self.weekDay = selectedWeekDay
        self.currentFilter = currentFilter
        self.searchText = searchText
        var predicates: [NSPredicate] = []
        
        let weekDayPredicate = NSPredicate(
            format: "timeTable CONTAINS %@",
            weekDay.rawValue
        )
        predicates.append(weekDayPredicate)
        
        switch currentFilter {
        case .all:
            break
            
        case .today:
           // сегодняшний день передается из контроллера
            break
        case .completed:
            let completedPredicate = NSPredicate(format: "trackerRecord.@count > 0")
            predicates.append(completedPredicate)
            
        case .unfinished:
            let unfinishedPredicate = NSPredicate(format: "trackerRecord.@count == 0")
            predicates.append(unfinishedPredicate)
        }

        if let searchText = searchText, !searchText.isEmpty {
            let searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            predicates.append(searchPredicate)
          
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchedResultsController.fetchRequest.predicate = compoundPredicate
        try? fetchedResultsController.performFetch()
        delegate?.didUpdateTrackersCollection()
    }
    
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
    
    func fetchCategory(tracker: Tracker) throws -> TrackerCoreDataCategory? {
         do {
             let category = try  trackerCategoryStore.findCategoryName( tracker.category)
             return category
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
    
    func deleteTracker(_ indexPath: IndexPath) throws {
       let tracker = fetchedResultsController.object(at: indexPath)
     
        do{
            try  trackerStore.deleteTracker(tracker: tracker)
        } catch {
            print("Failed to delete tracker: \(error)")
            throw error
        }
    }
    func createTracker(tracker: Tracker) throws {
        guard   let categoryCoreData = try fetchCategory(tracker: tracker) else{return}
      try?  trackerStore.createTracker(tracker: tracker, category: categoryCoreData)
    }
    
    func editTracker(trackerCoreData: TrackerCoreData, trackerNewData: Tracker) throws {
        guard let categoryCoreData = try fetchCategory(tracker: trackerNewData) else {return}
        
        do{
            try  trackerStore.editTracker(tracker: trackerCoreData, editTracker: trackerNewData, categoryCoreData: categoryCoreData)
        } catch {
            print("Failed to edit tracker: \(error)")
            throw error
        }
    }
   func trackersStoreNotIsEmpty() -> Bool {
       trackerStore.trackersStoreNotIsEmpty()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackersCollection()
    }

}
