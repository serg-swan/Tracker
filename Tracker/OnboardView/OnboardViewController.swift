//
//  OnboardViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import UIKit

final class OnboardViewController: UIViewController, UIScrollViewDelegate {
    
    private struct Page {
        let text: String
        let bgImageName: String
    }
    
    private let pages: [Page] = [
        Page(text: "Отслеживайте только то, что хотите", bgImageName: "onboardImage1"),
        Page(text: "Даже если это не литры воды и йога", bgImageName: "onboardImage2"),
    ]
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = pages.count
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = UIColor(named: "YP Black")
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "YP Black")
        button.layer.cornerRadius = 16
        button.tintColor = UIColor(named: "YP White")
        button.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(pages.count),
            height: view.frame.height
        )
        
        for (index, page) in pages.enumerated() {
            let xOffset = view.frame.width * CGFloat(index)
            let screenView = UIView(frame: CGRect(
                x: xOffset,
                y: 0,
                width: view.frame.width,
                height: view.frame.height
            ))
            
            let bgImage = UIImageView(frame: screenView.bounds)
            bgImage.image = UIImage(named: page.bgImageName)
            bgImage.contentMode = .scaleAspectFill
            bgImage.clipsToBounds = true
            screenView.addSubview(bgImage)
            
            let label = UILabel()
            label.text = page.text
            label.textAlignment = .center
            label.numberOfLines = 0
            label.textColor = UIColor(named: "YP Black")
            label.font = UIFont.boldSystemFont(ofSize: 32)
            
            screenView.addSubview(label)
            scrollView.addSubview(screenView)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: screenView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: screenView.trailingAnchor, constant: -16),
                label.centerYAnchor.constraint(equalTo: screenView.topAnchor, constant: screenView.bounds.height * 0.58),
            ])
        }
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134)
        ])
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func goToNextScreen() {
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
    
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
