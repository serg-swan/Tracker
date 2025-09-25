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
    private let textLabel = UILabel()
    private let searchController = UISearchController()
    private let placeholderView =  UIView()
    private var currentSelectedDate = Calendar.current.startOfDay(for: Date())
 
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackersDataProvider?.delegate = self
        updateVisibleTrackers(for: currentSelectedDate.weekDay())
        view.backgroundColor = UIColor(resource: .ypWhite)
        setupNavigationBarUI()
        setupTextLabelUI()
        setupSearchControllerUI()
        setupCollectionViewUI()
        addSubviews()
        setupPlaceholderViewUI()
        setupConstraints()
    }
    
    //MARK: Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            textLabel.widthAnchor.constraint(equalToConstant: 254),
            textLabel.heightAnchor.constraint(equalToConstant: 41),
            searchController.searchBar.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            searchController.searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            placeholderView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor, constant: 0),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
        ])
        
    }
    private func addSubviews() {
        view.addSubview(textLabel)
        view.addSubview(searchController.searchBar)
        view.addSubview(placeholderView)
        view.addSubview(collectionView)
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
    
    private func setupSearchControllerUI() {
        searchController.searchBar.isUserInteractionEnabled = false // поведение серчбара настроим в 17 спринте
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNavigationBarUI() {
        navigationItem.title = ""
        let plusButton = UIBarButtonItem(
            image: UIImage(resource: .plus),
            style: .plain,
            target: self,
            action: #selector(handlePlusButtonTapped)
        )
        plusButton.tintColor = UIColor(resource: .ypBlack)
        navigationItem.leftBarButtonItem = plusButton
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .clear
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_: )), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupTextLabelUI() {
        textLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textLabel.textColor = UIColor(resource: .ypBlack)
        textLabel.textAlignment = .left
        textLabel.text = "Трекеры"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func updatePlaceholderVisibility() {
        let hasData = (trackersDataProvider?.numberOfSections ?? 0) > 0
        DispatchQueue.main.async {
            self.placeholderView.isHidden = hasData
            self.collectionView.isHidden = !hasData
        }
    }
    private func updateVisibleTrackers(for weekDay: WeekDay) {
        trackersDataProvider?.updateFilter(for: weekDay)
        updatePlaceholderVisibility()
    }
    
    private func trackerCompleted(tracker: Tracker, category: String) {
      try?  trackersDataProvider?.fetchOrCreateCategory(tracker: tracker, category: category)
  let currentWeekDay = currentSelectedDate.weekDay()
        updateVisibleTrackers(for: currentWeekDay)
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
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker)  {
        let selectedDate = sender.date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        currentSelectedDate = startOfDay
        let selectedWeekDay = startOfDay.weekDay()
        updateVisibleTrackers(for: selectedWeekDay)
        print(currentSelectedDate)
    }
    
    @objc private func handlePlusButtonTapped() {
        let newTrackerVC = NewTrackerViewController()
        newTrackerVC.makeTracker = { [weak self] newTracker, categoryName in
            self?.trackerCompleted(tracker: newTracker, category: categoryName)
        }

        let navVC = UINavigationController(rootViewController: newTrackerVC)
        present(navVC, animated: true)
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

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
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
    
}

// MARK: UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      trackersDataProvider?.numberOfSections ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         trackersDataProvider?.numberOfRowsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.cellIdentifier, for: indexPath) as? TrackersCollectionViewCell else {
            fatalError("Невозможно создать ячейку типа TrackerCollectionViewCell")
        }
   
       guard let tracker = trackersDataProvider?.trackerObject(at: indexPath) else {
            fatalError("Невозможно создать ячейку типа TrackerCollectionViewCell")
        }
        
        let color = tracker.color ?? "YP Black"
        cell.trackerLabel.backgroundColor = UIColor(named: color)
        cell.delegate = self
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

extension TrackersViewController: TrackersDataProviderDelegate {
    func didUpdateTrackersCollection() {
        collectionView.reloadData()
    }
}


