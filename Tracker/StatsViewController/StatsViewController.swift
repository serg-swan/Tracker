//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import UIKit

final class StatsViewController: UIViewController {
    
    //MARK: Private methods
    private let placeholderView =  UIView()
    private var textLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let containerView = UIView()
    private var viewModel: ViewModel?
    private let gradientLayer = CAGradientLayer()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .ypWhite)
        addSubviews()
        setupNavigationBarUI()
        setupContainerViewUI()
        setupGradientLayer()
        setupStackViewUI()
        setupPlaceholderViewUI()
        viewModel?.loadRecordCount()
        AnalyticsService.reportEvent(event: .close, screen: .main)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    //MARK: Initializers
    
    func initialize(viewModel: ViewModel) {
        self.viewModel = viewModel
        bind()
    }
    //MARK: Private methods
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.recordUpdate = { [weak self] count in
            self?.updateUI(count)
        }
    }
    private func updateUI(_ count: String) {
        textLabel.text = count
        let hasData = count != "0"
        DispatchQueue.main.async {
            self.placeholderView.isHidden = hasData
            self.containerView.isHidden = !hasData
        }
    }
    
    private func setupNavigationBarUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Статистика"
    }
    private func addSubviews() {
        view.addSubview(placeholderView)
        view.addSubview(containerView)
        
    }
    private func setupStackViewUI() {
        textLabel.textAlignment = .left
        textLabel.textColor = UIColor(resource: .ypBlack)
        textLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Трекеров завершено"
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.textColor = UIColor(resource: .ypBlack)
        
        let stackView = UIStackView(arrangedSubviews: [textLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupContainerViewUI() {
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
    }
    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor(resource: .gradientRed).cgColor,
            UIColor(resource: .gradientGreen).cgColor,
            UIColor(resource: .gradientBlue).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 16
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.cornerRadius = 16
        
        gradientLayer.mask = shapeLayer
        containerView.layer.addSublayer(gradientLayer)
    }
    private func updateGradientFrame() {
        gradientLayer.frame = containerView.bounds
        if let mask = gradientLayer.mask as? CAShapeLayer {
            mask.path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 16).cgPath
        }
    }
    
    private func setupPlaceholderViewUI() {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .smile)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(resource: .ypBlack)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let questLabel = UILabel()
        questLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questLabel.textColor = UIColor(resource: .ypBlack)
        questLabel.textAlignment = .center
        questLabel.text = "Анализировать пока нечего"
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
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
