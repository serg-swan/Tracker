//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var trackersDataProvider: TrackersDataProviderProtocol?
    init(trackersDataProvider: TrackersDataProviderProtocol = TrackersDataProvider()) {
        self.trackersDataProvider = trackersDataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let datePicker = UIDatePicker()
    private let placeholderView =  UIView()
    private let placeholderFilterView =  UIView()
    private let filterButton = UIButton()
    private var currentSelectedDate = Calendar.current.startOfDay(for: Date())
    private var searchText: String? = nil
    private var currentFilter: TrackerFilter = .all {
        didSet {
           setFilter(currentFilter)
        }
    }
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsService.reportEvent(event: .open, screen: .main)
        trackersDataProvider?.delegate = self
        view.backgroundColor = UIColor(resource: .ypWhite)
        setupNavigationBarUI()
        setupCollectionViewUI()
        addSubviews()
        setupPlaceholderViewUI()
        setupPlaceholderFilterViewUI()
        setupFilterButton()
        setupConstraints()
        updateVisibleTrackers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let inset = filterButton.frame.height + 32
        collectionView.contentInset.bottom = inset
        collectionView.verticalScrollIndicatorInsets.bottom = inset
    }
    
    //MARK: Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -130),
            filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 131),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    private func addSubviews() {
        view.addSubview(placeholderView)
        view.addSubview(placeholderFilterView)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
    }
    
    private func setupCollectionViewUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.cellIdentifier)
        collectionView.register(TrackersCollectionSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackersCollectionSectionHeader.headerIdentifier)
    }
    
    private func setupNavigationBarUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let trackersString = NSLocalizedString("trackers", comment: "")
        navigationItem.title = trackersString
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        let plusButton = UIBarButtonItem(
            image: UIImage(resource: .plus),
            style: .plain,
            target: self,
            action: #selector(handlePlusButtonTapped)
        )
        plusButton.tintColor = UIColor(resource: .ypBlack)
        navigationItem.leftBarButtonItem = plusButton
        let datePicker = self.datePicker
        datePicker.backgroundColor = .clear
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = Date()
        navigationController?.navigationBar.shadowImage = UIImage()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
    }
    
    private func setupPlaceholderViewUI() {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .star)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(resource: .ypBlack)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let questLabel = UILabel()
        questLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questLabel.textColor = UIColor(resource: .ypBlack)
        questLabel.textAlignment = .center
        questLabel.text = "Что будем отслеживать?"
        questLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, questLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.backgroundColor = .clear
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: placeholderView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: placeholderView.trailingAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    private func setupPlaceholderFilterViewUI() {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .smile)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(resource: .ypBlack)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let questLabel = UILabel()
        questLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questLabel.textColor = UIColor(resource: .ypBlack)
        questLabel.textAlignment = .center
        questLabel.text = "Ничего не найдено"
        questLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, questLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        placeholderFilterView.backgroundColor = .clear
        placeholderFilterView.translatesAutoresizingMaskIntoConstraints = false
        placeholderFilterView.isHidden = true
        placeholderFilterView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: placeholderFilterView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: placeholderFilterView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: placeholderFilterView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: placeholderFilterView.trailingAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderFilterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderFilterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            placeholderFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderFilterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupFilterButton() {
        let filtersString = NSLocalizedString("filters", comment: "")
        filterButton.setTitle(filtersString, for: .normal)
        filterButton.backgroundColor = UIColor(resource: .ypBlue)
        filterButton.layer.cornerRadius = 16
        filterButton.clipsToBounds = true
        filterButton.setTitleColor(currentFilter.colorButton, for: .normal)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.isHidden = true
        filterButton.addTarget(self, action: #selector(handleFilterButtonTapped), for: .touchUpInside)
      
    }
    
    private func updatePlaceholderVisibility() {
        let hasTrackers = trackersDataProvider?.trackersStoreNotIsEmpty() ?? false
        let hasVisibleSections = (trackersDataProvider?.numberOfSections ?? 0) > 0

        DispatchQueue.main.async {
            if !hasTrackers {
                self.placeholderView.isHidden = false
                self.placeholderFilterView.isHidden = true
                self.filterButton.isHidden = true
            } else if hasTrackers && !hasVisibleSections {
                self.placeholderView.isHidden = true
                self.placeholderFilterView.isHidden = false
                self.filterButton.isHidden = true
            } else {
                self.placeholderView.isHidden = true
                self.placeholderFilterView.isHidden = true
                self.filterButton.isHidden = false
            }
        }
    }
    private func updateVisibleTrackers() {
        let weekDay = self.currentSelectedDate.weekDay()
        trackersDataProvider?.updateFilter(selectedWeekDay: weekDay, currentFilter: self.currentFilter, searchText: self.searchText)
    }
    
    private func trackerCompleted(tracker: Tracker) {
        try?  trackersDataProvider?.createTracker(tracker: tracker)
        updateVisibleTrackers()
    }
    private func trackerEditCompleted(trackerCoreData: TrackerCoreData, tracker: Tracker) {
       try?  trackersDataProvider?.editTracker(trackerCoreData: trackerCoreData, trackerNewData: tracker)
        updateVisibleTrackers()
    }
    
    private  func hasRecordForDate(tracker: TrackerCoreData) -> Bool {
        guard let records = tracker.trackerRecord as? Set<TrackerCoreDataRecord> else {
            return false
        }
      
        return records.contains { record in
            guard let recordDate = record.date else { return false }
            return recordDate == currentSelectedDate
        }
    }
    
    private func editTracker(at: IndexPath) {
        guard let oldTracker = trackersDataProvider?.trackerObject(at: at) else {
            fatalError("Невозможно получить трекер ")
        }
        let category = oldTracker.trackerCategory?.categoryName ?? ""
        let trackerName = oldTracker.name ?? ""
        let recordCount = oldTracker.trackerRecord?.count ?? 0
        let timeTable = oldTracker.timeTable
        let color = oldTracker.color ?? ""
        let emoji = oldTracker.emoji ?? ""
        let editTrackerVC = EditTrackerViewController.init(categoryName: category, name: trackerName, emoji: emoji, color: color, record: recordCount, timeTable: timeTable as! [WeekDay])
        
       editTrackerVC.editTracker = { [weak self] newDataTracker in
           self?.trackerEditCompleted(trackerCoreData: oldTracker, tracker: newDataTracker)
        }
        
        let navVC = UINavigationController(rootViewController: editTrackerVC)
        present(navVC, animated: true)
    }
    
    private func deleteTracker(indexPath: IndexPath) {
        let actionSheet = UIAlertController(
            title: "Уверены что хотите удалить трекер?", message: nil, preferredStyle: .actionSheet
        )
        let deleteCategory = UIAlertAction(
            title: "Удалить", style: .destructive
        ){ _ in
            try? self.trackersDataProvider?.deleteTracker(indexPath)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
      actionSheet.addAction(deleteCategory)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
    func setFilter(_ filter: TrackerFilter) {
        if currentFilter == .today {
            datePicker.setDate(Date(), animated: false)
              datePickerValueChanged(datePicker)
        }
        else {
            updateVisibleTrackers()
        }
    }
    
    //MARK: - Actions
    @objc private func datePickerValueChanged(_ sender: UIDatePicker)  {
        let selectedDate = sender.date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        currentSelectedDate = startOfDay
        updateVisibleTrackers()
    }
    
    @objc private func handlePlusButtonTapped() {
        let newTrackerVC = NewTrackerViewController()
        
        newTrackerVC.makeTracker = { [weak self] newTracker in
            self?.trackerCompleted(tracker: newTracker)
        }
        
        let navVC = UINavigationController(rootViewController: newTrackerVC)
        present(navVC, animated: true)
        AnalyticsService.reportEvent(event: .click, screen: .main, item: .addTrack)
    }
    
    @objc private func handleFilterButtonTapped() {
        let filterVC = FiltersViewController()
        filterVC.selectedFilter = currentFilter
        filterVC.onFilterChange = { [weak self] filter in
            self?.currentFilter = filter
            self?.filterButton.setTitleColor(filter.colorButton, for: .normal)
        }
        let navVC = UINavigationController(rootViewController: filterVC)
        present(navVC, animated: true)
        AnalyticsService.reportEvent(event: .click, screen: .main, item: .filter)
    }
}

// MARK: TrackerCollectionViewCellDelegate

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func updateCompletedTrackers(_ cell: TrackersCollectionViewCell) {
        let calendar = Calendar.current
        let currentDate = currentSelectedDate
        guard currentDate  <= calendar.startOfDay(for: Date()) else { return }
        guard let indexPath = collectionView.indexPath(for: cell)
                
        else { return }
        guard let tracker = trackersDataProvider?.trackerObject(at: indexPath) else { return  }
        try?  trackersDataProvider?.addOrDeleteTrackerRecord(tracker: tracker, date: currentDate)
        collectionView.reloadItems(at: [indexPath])
    }
}

//MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.searchText = searchText
                  updateVisibleTrackers()
               } else {
                   self.searchText = nil
                  updateVisibleTrackers()
               }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat
        if section == 0 {
            height = 54
        } else {
            height = 46
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.bounds.width)-42) / 2, height: 148)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView,
                       previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else {
            return nil
        }
        let cardView = cell.trackerLabel
        let parameters = UIPreviewParameters()
        parameters.visiblePath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 16)
        
        return UITargetedPreview(view: cardView, parameters: parameters)
    }
   
    func collectionView(_ collectionView: UICollectionView,
                       contextMenuConfigurationForItemAt indexPath: IndexPath,
                       point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать") { _ in
                self.editTracker(at: indexPath)
                AnalyticsService.reportEvent(event: .click, screen: .main, item: .edit)
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
                self.deleteTracker(indexPath: indexPath)
                AnalyticsService.reportEvent(event: .click, screen: .main, item: .delete)
            }
            
            return UIMenu(children: [editAction, deleteAction])
        }
    }
    
}

// MARK: UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       updatePlaceholderVisibility()
       return trackersDataProvider?.numberOfSections ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackersDataProvider?.numberOfRowsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.cellIdentifier, for: indexPath) as? TrackersCollectionViewCell else {
            fatalError("Невозможно создать ячейку типа TrackerCollectionViewCell")
        }
        
        guard let tracker = trackersDataProvider?.trackerObject(at: indexPath) else {
            fatalError("Невозможно получить трекер ")
        }
        cell.delegate = self
        let color = tracker.color ?? "YP Black"
        cell.trackerLabel.backgroundColor = UIColor(named: color)
        cell.nameLabel.text = tracker.name
        cell.emojiLabel.text = tracker.emoji
        let completedCount = tracker.trackerRecord?.count ?? 0
        cell.dayString(for: completedCount)
        let isCompletedToday = hasRecordForDate(tracker: tracker)
        cell.setCompleted(isCompletedToday, color: UIColor(named: color) ?? .clear)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackersCollectionSectionHeader.headerIdentifier, for: indexPath) as? TrackersCollectionSectionHeader else {
            fatalError("Невозможно создать хедер")
        }
        
        let text = trackersDataProvider?.categoryObject(at: indexPath)
        view.titleLabel.text = text
        
        return view
    }
    
}
//MARK: - TrackersDataProviderDelegate
extension TrackersViewController: TrackersDataProviderDelegate {
    func didUpdateTrackersCollection() {
        collectionView.reloadData()
    }
}


