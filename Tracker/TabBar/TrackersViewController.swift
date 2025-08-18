//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import UIKit
protocol TrackersViewControllerDelegate: AnyObject {
    func didSelectTracker(_ tracker: Tracker)
}

final class TrackersViewController: UIViewController {
    
    // MARK: Private Properties
    
    private var trackers: [Tracker] = []
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let textLabel = UILabel()
    private let searchController = UISearchController()
    private let placeholderView =  UIView()
    private let cellIdentifier = "cell"
    private let headerIdentifier = "header"
    private var currentSelectedDate = Date()
    private var displayCategories: [TrackerCategory] = []
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateVisibleTrackers(for: currentSelectedDate.weekDay())
        collectionView.dataSource = self
        collectionView.delegate = self
        view.backgroundColor = UIColor(named: "YP White")
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
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(SupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
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
            image: UIImage(named: "plusImage"),
            style: .plain,
            target: self,
            action: #selector(handlePlusButtonTapped)
        )
        plusButton.tintColor = UIColor(named: "YP Black")
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
        textLabel.textColor = UIColor(named: "YP Black")
        textLabel.textAlignment = .left
        textLabel.text = "Трекеры"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPlaceholderViewUI() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "YP Black")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let questLabel = UILabel()
        questLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questLabel.textColor = UIColor(named: "YP Black")
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
    
    private func placeholderIsHiddenUI() {
        let hasTrackers = displayCategories.isEmpty
        DispatchQueue.main.async {
            self.placeholderView.isHidden = !hasTrackers
            self.collectionView.isHidden = hasTrackers
        }
    }
    private func updateVisibleTrackers(for weekDay: WeekDay) {
        guard !categories.isEmpty else {
            displayCategories = []
            collectionView.reloadData()
            self.placeholderIsHiddenUI()
            return
        }
        displayCategories = categories.compactMap { category in
            let activeTrackers = category.trackers.filter { $0.timetable.contains(weekDay) }
            return activeTrackers.isEmpty ? nil : TrackerCategory(
                categoryName: category.categoryName,
                trackers: activeTrackers
            )
        }
        collectionView.reloadData()
        self.placeholderIsHiddenUI()
    }
    
    
    private func trackerCompleted(newCategory: TrackerCategory) {
        if let existingIndex = categories.firstIndex(where: { $0.categoryName == newCategory.categoryName }) {
            let existingCategory = categories[existingIndex]
            let combinedTrackers = existingCategory.trackers + newCategory.trackers
            categories[existingIndex] = existingCategory.with(trackers: combinedTrackers)
            
        } else {
            categories.append(newCategory)
        }
        let currentWeekDay = currentSelectedDate.weekDay()
        updateVisibleTrackers(for: currentWeekDay)
        
    }
    
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker)  {
        let selectedDate = sender.date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        currentSelectedDate = startOfDay
        let selectedWeekDay = startOfDay.weekDay()
        updateVisibleTrackers(for: selectedWeekDay)
    }
    
    @objc private func handlePlusButtonTapped() {
        let newTrackerVC = NewTrackerViewController()
        newTrackerVC.makeTracker = { [weak self] newValue in
            self?.trackerCompleted(newCategory: newValue)
            
        }
        let navVC = UINavigationController(rootViewController: newTrackerVC)
        present(navVC, animated: true)
    }

}

// MARK: TrackerCollectionViewCellDelegate

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func updateCompletedTrackers(_ cell: TrackerCollectionViewCell) {
        let calendar = Calendar.current
        let currentDate = currentSelectedDate
        guard currentDate  <= calendar.startOfDay(for: Date()) else { return }
        guard let indexPath = collectionView.indexPath(for: cell),
              indexPath.section < displayCategories.count,
              indexPath.item < displayCategories[indexPath.section].trackers.count else { return }
        let tracker = displayCategories[indexPath.section].trackers[indexPath.item]
        if let index = completedTrackers.firstIndex(where: { record in
            record.trackerId == tracker.id &&  calendar.isDate(record.date, inSameDayAs: self.currentSelectedDate)
        }) {
            completedTrackers.remove(at: index)
        } else {
            let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)
            completedTrackers.append(trackerRecord)
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell {
            let count = completedTrackers.filter { $0.trackerId == tracker.id }.count
            cell.dayString(for: count)
        }
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
        return displayCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            fatalError("Невозможно создать ячейку типа TrackerCollectionViewCell")
        }
        let tracker = displayCategories[indexPath.section].trackers[indexPath.item]
        let color = UIColor(named: tracker.color) ?? .clear
        cell.trackerLabel.backgroundColor = color
        cell.delegate = self
        cell.nameLabel.text = tracker.name
        cell.emojiLabel.text = tracker.emoji
        let completedCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        cell.dayString(for: completedCount)
        let calendar = Calendar.current
        let isCompletedToday = completedTrackers.contains { record in
            record.trackerId == tracker.id && calendar.isDate(record.date, inSameDayAs: currentSelectedDate)
        }
        cell.setCompleted(isCompletedToday, color: color)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? SupplementaryView else {
            fatalError("Невозможно создать хедер")
        }
        
        view.titleLabel.text = displayCategories[indexPath.section].categoryName
        return view
    }
    
}


