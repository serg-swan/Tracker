//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: Private Properties
    private let plusButton = UIButton()
    private var datePicker = UIDatePicker()
    private var textLabel = UILabel()
    private let searchBar = UISearchBar()
    private let imageView = UIImageView()
    private var questLabel = UILabel()
    private let containerView =  UIView()
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, questLabel])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White")
        setupPlusButtonUI()
        setupDatePickerUI()
        setupTextLabelUI()
        setupSearchBarUI()
        setupStackViewUI()
        setupContainerViewUI()
        imageViewUI()
        questLabelUI()
        addSubviews()
        setupConstraints()
    }
    
    
    //MARK: Private Methods
   
    
    private func setupConstraints() {
   
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
            plusButton.heightAnchor.constraint(equalToConstant: 44),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            datePicker.heightAnchor.constraint(equalTo: plusButton.heightAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            textLabel.widthAnchor.constraint(equalToConstant: 254),
            textLabel.heightAnchor.constraint(equalToConstant: 41),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6),
            searchBar.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 7),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            questLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            questLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
          
            
        ])
        
    }
    private func addSubviews() {
        view.addSubview(plusButton)
        view.addSubview(datePicker)
        view.addSubview(textLabel)
        view.addSubview(searchBar)
        view.addSubview(containerView)
        containerView.addSubview(stackView)
       
    }
 
    
    private func setupPlusButtonUI() {
        plusButton.setImage(UIImage(named: "plusImage"), for: .normal)
        plusButton.backgroundColor = .clear
        plusButton.translatesAutoresizingMaskIntoConstraints = false
       
    }
    
    private func setupDatePickerUI() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .clear
        datePicker.date = Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
   private func setupTextLabelUI() {
        textLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textLabel.textColor = UIColor(named: "YP Black")
        textLabel.textAlignment = .left
        textLabel.text = "Трекеры"
       textLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSearchBarUI() {
        searchBar.barTintColor = .clear
        searchBar.placeholder = "Поиск"
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = UIColor(named: "searchBackground")
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.textColor = .clear
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    private func imageViewUI() {
        imageView.image = UIImage(named: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "YP Black")
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func questLabelUI() {
        questLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questLabel.textColor = UIColor(named: "YP Black")
        questLabel.textAlignment = .center
        questLabel.text = "Что будем отслеживать?"
        questLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupStackViewUI() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        imageView.contentMode = .scaleAspectFit
        questLabel.textAlignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
    
        
    }
    private func setupContainerViewUI() {
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
}
