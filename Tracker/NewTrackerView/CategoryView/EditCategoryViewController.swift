//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 19.09.2025.
//

import UIKit
final class EditCategoryViewController: UIViewController {
    private lazy var textField = UITextField()
    private let returnButton = UIButton()
    private var viewModel: CategoryViewModel?
   
    private lazy var indexPath: IndexPath = .init(row: 0, section:  0)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupGesture()
        setupTextFieldUI()
        setupReturnButtonUI()
    }
    func initialize(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
     bind()
    }
    
   func bind() {
       guard let viewModel = viewModel else { return }
       viewModel.indexPath = { [weak self] indexPath in
           self?.indexPath = indexPath
       }
    }
    //MARK: - Private methods
    private func makeButtonIsEnabled() {
        guard let viewModel else { return }
        if !viewModel.newNameCategory.isEmpty {
            returnButton.isEnabled = true
            returnButton.backgroundColor = UIColor(resource: .ypBlack)
            
        }
    }
    private func setupView() {
          view.backgroundColor = UIColor(resource: .ypWhite)
      }
      
      private func setupNavigationBar() {
          title = "Редактирование категории"
          navigationController?.navigationBar.titleTextAttributes = [
              .font: UIFont.systemFont(ofSize: 16, weight: .medium)
          ]
      }
      
      private func setupGesture() {
          let tapGesture = UITapGestureRecognizer(
              target: self,
              action: #selector(dismissKeyboard)
          )
          tapGesture.cancelsTouchesInView = false
          view.addGestureRecognizer(tapGesture)
      }
    
    private func setupTextFieldUI() {
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        textField.text = viewModel?.object(at: indexPath)
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
    
    private func setupReturnButtonUI() {
        returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        returnButton.setTitleColor(UIColor(named: "YP White"), for: .normal)
        returnButton.backgroundColor = UIColor(resource: .ypGray)
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
    
    //MARK: - Action
    @objc private func returnButtonTapped() {
        guard let viewModel else { return }
        let newName = viewModel.newNameCategory
        try?  viewModel.updateCategory(indexPath:  indexPath, newName: newName)
               dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
// MARK: - UITextFieldDelegate
extension EditCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.newNameCategory = textField.text ?? ""
        makeButtonIsEnabled()
        
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= 38
    }
}


