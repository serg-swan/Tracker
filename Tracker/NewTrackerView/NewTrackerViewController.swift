//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 10.08.2025.
//
import UIKit

struct TableviewCellData {
    var title: String
    var subtitle: String?
}

struct CollectionViewData {
    let name: String
    var cellData: [String]
}

final class NewTrackerViewController: UIViewController {
    
    var makeTracker: ((Tracker, String) -> Void)? // этот метод уладить и соханять в кордвту
    
    // MARK: Private Properties
    
    private var categoryName = "Работа"
    private var name: String = ""
    private var emoji: String = ""
    private var color: String = ""
    private let emojiArray: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colorArray: [String] = [
        "Color1", "Color2", "Color3", "Color4", "Color5", "Color6",
        "Color7", "Color8", "Color9", "Color10", "Color11", "Color12",
        "Color13", "Color14", "Color15", "Color16", "Color17", "Color18"
    ]
    
    
    private lazy var collectionViewDataSource: [CollectionViewData] = [
        CollectionViewData(name: "Emoji", cellData: emojiArray),
        CollectionViewData(name: "Цвет", cellData: colorArray)
    ]
    
    
    private var timeTable: [WeekDay] = []
    
    private lazy var textField = UITextField()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var makeButton = UIButton()
    private lazy var cancelButton = UIButton()
    
    
    private let tableViewCellIdentifier = "cell"
    private var items = [
        TableviewCellData(title: "Категория", subtitle: nil),
        TableviewCellData(title: "Расписание", subtitle: nil)
    ]
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .ypWhite)
        title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        setupTextFieldUI()
        setupTableViewUI()
        setupCancelButtonUI()
        setupMakeButtonUI()
        setupCollectionViewUI()
    }
    
    //MARK: Private Methods
    
    private func setupTextFieldUI() {
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.textColor = UIColor(resource: .ypBlack)
        textField.borderStyle = .none
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = UIColor(resource: .ypBackground)
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    
    private func setupTableViewUI() {
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 149)
        ])
    }
    
    private func setupCollectionViewUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NewTrackerCollectionViewCell.self, forCellWithReuseIdentifier: NewTrackerCollectionViewCell.cellIdentifier)
        collectionView.register(NewTrackerCollectionSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: NewTrackerCollectionSectionHeader.headerIdentifier)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16)
        ])
    }
    
    
    private func setupCancelButtonUI() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.setTitleColor(UIColor(resource: .ypRed), for: .normal)
        cancelButton.layer.borderWidth = 1.0 // UIScreen.main.scale
        cancelButton.layer.borderColor = UIColor(resource: .ypRed).cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cancelButton.setTitle("Отмена", for: .normal)
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    private func setupMakeButtonUI() {
        makeButton.addTarget(self, action: #selector(makeButtonTapped), for: .touchUpInside)
        makeButton.setTitleColor(UIColor(resource: .ypWhite), for: .normal)
        makeButton.backgroundColor = UIColor(resource: .ypGray)
        makeButton.layer.cornerRadius = 16
        makeButton.layer.masksToBounds = true
        makeButton.isEnabled = false
        makeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        makeButton.setTitle("Создать", for: .normal)
        view.addSubview(makeButton)
        makeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            makeButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            makeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            makeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            makeButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    private func makeButtonIsEnabled() {
        if !name.isEmpty && !timeTable.isEmpty && !emoji.isEmpty && !color.isEmpty  && !categoryName.isEmpty {
            makeButton.isEnabled = true
            DispatchQueue.main.async {
                self.makeButton.backgroundColor = UIColor(resource: .ypBlack)
            }
        }
    }
    
    private func showWeekDaySelector(for indexPath: IndexPath) {
        let weekDayVC = WeekDayViewController()
        weekDayVC.onDaysSelected = { [weak self] selectedDays in
            self?.handleDaySelection(selectedDays, for: indexPath)
        }
        let navVC = UINavigationController(rootViewController: weekDayVC)
        present(navVC, animated: true)
    }
    
    private func handleDaySelection(_ days: [WeekDay], for indexPath: IndexPath) {
        timeTable = days
        updateCell(at: indexPath, with: days)
        self.makeButtonIsEnabled()
    }
    
    private func updateCell(at indexPath: IndexPath, with days: [WeekDay]) {
        if days.count == 7 {
            items[indexPath.row].subtitle = "Каждый день"
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        } else {
            items[indexPath.row].subtitle = days.map { $0.rawValue }.joined(separator: ", ")
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func  makeButtonTapped() {
        let newTracker = Tracker.newTracker(name: name, emoji: emoji, color: color, timeTable: timeTable)
        //let trackerCategory = TrackerCategory(categoryName: categoryName, trackers: [newTracker])
        
        makeTracker?(newTracker, categoryName)
        name = ""
        emoji = ""
        color = ""
        timeTable = []
        dismiss(animated: true)
    }
    
    @objc private func  cancelButtonTapped() {
        name = ""
        timeTable = []
        dismiss(animated: true)
        
    }
    
}

// MARK:  UITextFieldDelegate

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        name = textField.text ?? ""
        self.makeButtonIsEnabled()
        
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= 38
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension NewTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: tableViewCellIdentifier)
        let item = items[indexPath.row]
        cell.backgroundColor = UIColor(resource: .ypBackground)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.textColor = UIColor(resource: .ypGray)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.text = item.subtitle ?? ""
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            showWeekDaySelector(for: indexPath)
        } else {
            
            items[indexPath.row].subtitle = categoryName
            self.makeButtonIsEnabled()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource[section].cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewTrackerCollectionViewCell.cellIdentifier, for: indexPath) as? NewTrackerCollectionViewCell else {
            fatalError("Невозможно создать ячейку типа NewTrackerCollectionViewCell")
        }
        cell.titleLabel.text = ""
        cell.titleLabel.layer.cornerRadius = 8
        cell.titleLabel.layer.masksToBounds = true
        cell.titleLabel.textAlignment = .center
        cell.titleLabel.backgroundColor = .clear
        cell.activeImageView.isHidden = true
        cell.backgroundColor = .clear
        
        let section = indexPath.section
        switch section {
        case 0:
            if indexPath == selectedEmojiIndexPath {
                print(indexPath)
                cell.backgroundColor = UIColor(resource: .ypLightGray)
            }
            let text = collectionViewDataSource[section].cellData[indexPath.item]
            cell.titleLabel.text = text
            cell.layer.cornerRadius = 16
           
        case 1:
            let colorName = collectionViewDataSource[section].cellData[indexPath.item]
            let color = UIColor(named: colorName) ?? .clear
            if indexPath == selectedColorIndexPath {
                cell.setCompleted(color)
            }
           
            cell.titleLabel.backgroundColor = color
            cell.layer.cornerRadius = 11.0
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NewTrackerCollectionSectionHeader.headerIdentifier, for: indexPath) as? NewTrackerCollectionSectionHeader else {
            fatalError("Невозможно создать хедер")
        }
        let text = collectionViewDataSource[indexPath.section].name
        view.titleLabel.text = text
        
        return view
    }
}

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat
        if section == 0 {
            height = 50
        } else {
            height = 34
        }
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calculatedWidth = (collectionView.bounds.width - 32) / 6
        let maxWidth: CGFloat = 52
        let width = min(calculatedWidth, maxWidth)
        let height = width
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            emoji = collectionViewDataSource[section].cellData[indexPath.item]
            selectedEmojiIndexPath = indexPath
            self.makeButtonIsEnabled()
            collectionView.reloadData()
            
        case 1:
            color = collectionViewDataSource[section].cellData[indexPath.item]
            selectedColorIndexPath = indexPath
            self.makeButtonIsEnabled()
            collectionView.reloadData()
            
        default:
            break
        }
    }
}
    

