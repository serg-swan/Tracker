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

final class NewTrackerViewController: UIViewController {
    
    var makeTracker: ((TrackerCategory) -> Void)?
    
    // MARK: Private Properties
    
    private var categoryName = "Работа"
    private var name:String = ""
    private var emoji: String = "💼"
    private var color: String = "YP Blue"
    private var timeTable: [WeekDay] = []
    
   
    private let textField = UITextField()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let makeButton = UIButton()
    private let cancelButton = UIButton()
    private let cellIdentifier = "cell"
    private var items = [
        TableviewCellData(title: "Категория", subtitle: nil),
        TableviewCellData(title: "Расписание", subtitle: nil)
    ]
    
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
    }
    
    //MARK: Private Methods
    
    private func setupTextFieldUI() {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 149)
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
        makeButton.isEnabled = !name.isEmpty && !timeTable.isEmpty && !emoji.isEmpty && !color.isEmpty  && !categoryName.isEmpty
        makeButton.backgroundColor = UIColor(resource: .ypBlack)
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
        DispatchQueue.main.async {
            self.makeButtonIsEnabled()
        }
        updateCell(at: indexPath, with: days)
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
        let trackerCategory = TrackerCategory(categoryName: categoryName, trackers: [newTracker])
        
        makeTracker?(trackerCategory)
        name = ""
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
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
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



