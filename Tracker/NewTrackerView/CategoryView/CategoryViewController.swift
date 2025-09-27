//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 11.09.2025.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    //MARK: - Private properties
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var newCategoryButton = UIButton()
    private var selectedCategories: String = ""
    private let placeholderView =  UIView()
    private var viewModel: CategoryViewModel?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .ypWhite)
        title = "Категория"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        setupReturnButtonUI()
        setupTableViewUI()
        setupPlaceholderViewUI()
        tableView.reloadData()
        updatePlaceholderVisibility()
    }
    func initialize(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        bind()
    }
    private func bind() {
        guard let viewModel = viewModel else { return }
      
        viewModel.categoriesUpdate = { [weak self]  in
                self?.updatePlaceholderVisibility()
                self?.tableView.reloadData()
        }
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
        questLabel.numberOfLines = 0
        questLabel.text = "Привычки и события можно\nобъединить по смыслу"
        questLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, questLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.backgroundColor = .clear
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderView)
        placeholderView.addSubview(stackView)
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            placeholderView.bottomAnchor.constraint(equalTo: newCategoryButton.topAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: placeholderView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: placeholderView.trailingAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    private func updatePlaceholderVisibility() {
        guard let viewModel else { return }
                let hasData = viewModel.fetchedObjects() != 0
        DispatchQueue.main.async {
            self.placeholderView.isHidden = hasData
            self.tableView.isHidden = !hasData
        }
    }
   
    
    private func setupTableViewUI() {
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = true
        tableView.register(NewCategoryTableViewCell.self, forCellReuseIdentifier: NewCategoryTableViewCell.cellIdentifier)
        tableView.allowsMultipleSelection = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: newCategoryButton.topAnchor, constant: -24)
        ])
    }
    
    private func setupReturnButtonUI() {
        newCategoryButton.addTarget(self, action: #selector(newCategoryButtonTapped), for: .touchUpInside)
        newCategoryButton.setTitleColor(UIColor(named: "YP White"), for: .normal)
        newCategoryButton.backgroundColor = UIColor(named: "YP Black")
        newCategoryButton.layer.cornerRadius = 16
        newCategoryButton.layer.masksToBounds = true
        newCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        newCategoryButton.setTitle("Добавить категорию", for: .normal)
        view.addSubview(newCategoryButton)
        newCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            newCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            ])
    }
    //MARK: - Action
    @objc private func newCategoryButtonTapped(){
    
        let nevCategoryVC = NewCategoryViewController()
        let model = TrackerCategoryDataProvider()
        let viewModel = CategoryViewModel(for: model)
        nevCategoryVC.initialize(viewModel: viewModel)
        let navVC = UINavigationController(rootViewController: nevCategoryVC)
        present(navVC, animated: true)
    }
}
//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewCategoryTableViewCell.cellIdentifier, for: indexPath) as? NewCategoryTableViewCell else {
            return UITableViewCell()
        }
       guard let viewModel else { return UITableViewCell() }
        let count = viewModel.fetchedObjects()
        cell.layer.maskedCorners = []
        if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if indexPath.row == count - 1 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        cell.titleLabel.text = viewModel.object(at: indexPath)
        if cell.titleLabel.text == viewModel.categorySelect {
            cell.accessoryType = .checkmark
            print(selectedCategories)
        } else {
            cell.accessoryType = .none
            print(selectedCategories)
        }
       
        if indexPath.row == count - 1 {
            cell.separator.isHidden = true
           
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.fetchedObjects() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel else { return }
        viewModel.categorySelect = viewModel.object(at: indexPath)
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                   self.dismiss(animated: true)
               }
    }
   
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(
                identifier: indexPath as NSCopying,
                previewProvider: nil
            ) { _ in
                let editAction = UIAction(
                    title: "Редактировать"
                ) { [weak self] _ in
                    self?.editCategory(indexPath)
                }
                
                let deleteAction = UIAction(
                    title: "Удалить",
                    attributes: .destructive
                ) { [weak self] _ in
                    self?.deleteCategory(indexPath: indexPath)
                }
                
                return UIMenu(children: [editAction, deleteAction])
            }
        }
        
        private func editCategory(_ indexPath: IndexPath) {
                let editCategoryVC = EditCategoryViewController()
                let model = TrackerCategoryDataProvider()
                let viewModel = CategoryViewModel(for: model)
                editCategoryVC.initialize(viewModel: viewModel)
                viewModel.indexPath?(indexPath)
                let navVC = UINavigationController(rootViewController: editCategoryVC)
                present(navVC, animated: true)
        }
        
        private func deleteCategory(indexPath: IndexPath) {
            try? viewModel?.deleteCategory(indexPath: indexPath)
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
            
        }
    }
    
