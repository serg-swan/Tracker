//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 11.09.2025.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    //MARK: - Private properties
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    var selectedFilter: TrackerFilter = .all {
        didSet {
            onFilterChange?(selectedFilter)
        }
    }
    private let cellIdentifier = "FiltersViewControllerViewControllerCell"
    var onFilterChange: ((TrackerFilter) -> Void)?
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .ypWhite)
        title = "Фильтры"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        setupTableViewUI()
        tableView.reloadData()
    }
    
    private func setupTableViewUI() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = UIColor(resource: .ypGray)
        tableView.tableHeaderView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsMultipleSelection = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
}
//MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLast = indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1)
        if isLast {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        cell.backgroundColor = UIColor(resource: .ypBackground)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.text = TrackerFilter.allCases[indexPath.row].rawValue
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.layer.maskedCorners = []
        if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if indexPath.row == 3 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        if indexPath.row >= 2 && cell.textLabel?.text == selectedFilter.rawValue {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrackerFilter.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedFilter = TrackerFilter.allCases[indexPath.row]
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true)
        }
    }
    
}

