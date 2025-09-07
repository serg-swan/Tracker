//
//  WeekDayViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 12.08.2025.
//


import UIKit
final class WeekDayViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let returnButton = UIButton()
    private let cellIdentifier = "cell2"
    private let days = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    var selectedDays: [WeekDay] = []
    var onDaysSelected: (([WeekDay]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White")
        title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        setupReturnButtonUI()
        setupTableViewUI()
       
        
    }
    
    private func setupTableViewUI() {
       

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
      
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: returnButton.topAnchor, constant: -24)
         
        ])
    }
    
    private func setupReturnButtonUI() {
        returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        returnButton.setTitleColor(UIColor(named: "YP White"), for: .normal)
        returnButton.backgroundColor = UIColor(named: "YP Black")
        returnButton.layer.cornerRadius = 16
        returnButton.layer.masksToBounds = true
        returnButton.isEnabled = false
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        returnButton.setTitle("Готово", for: .normal)
        view.addSubview(returnButton)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: 60),
            ])
    }
    
    @objc private func switchValueDidChange(_ sender: UISwitch){
        guard let weekDay = WeekDay.allCases[safe: sender.tag] else {
              print("Ошибка: неверный tag у свитча") 
              return
          }
          
          if sender.isOn {
              selectedDays.append(weekDay)
          } else {
              selectedDays.removeAll { $0 == weekDay }
          }
          returnButton.isEnabled = !selectedDays.isEmpty
      }

    
    @objc private func returnButtonTapped(){
        onDaysSelected?(selectedDays)
        selectedDays.removeAll()
               dismiss(animated: true)
    }
}

extension WeekDayViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.layer.maskedCorners = []
        if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if indexPath.row == 6 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        cell.backgroundColor = UIColor(resource: .ypBackground)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.text = days[indexPath.row]
        let switchControl = UISwitch()
        switchControl.onTintColor = .systemBlue
        switchControl.tag = indexPath.row
        switchControl.isOn = false
        switchControl.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        cell.accessoryView = switchControl
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


