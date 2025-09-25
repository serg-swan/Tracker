//
//  OnboardViewController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import UIKit

final class OnboardViewController:  UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
    lazy var pages: [UIViewController] = {
        let leftController = UIViewController()
        let bgImage = UIImageView()
        bgImage.image = UIImage(resource: .onboardImage1)
        bgImage.contentMode = .scaleAspectFill
        bgImage.clipsToBounds = true
      
        let label = UILabel()
        label.text = "Отслеживайте только то, что хотите"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "YP Black")
        label.font = UIFont.boldSystemFont(ofSize: 32)
        leftController.view.addSubview(bgImage)
        leftController.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgImage.leadingAnchor.constraint(equalTo: leftController.view.leadingAnchor),
                   bgImage.trailingAnchor.constraint(equalTo: leftController.view.trailingAnchor),
                   bgImage.topAnchor.constraint(equalTo: leftController.view.topAnchor),
                   bgImage.bottomAnchor.constraint(equalTo: leftController.view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leftController.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: leftController.view.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: leftController.view.topAnchor, constant: view.bounds.height * 0.58),
        ])
        
        let rightController = UIViewController()
        let bgImageRight = UIImageView()
        bgImageRight.image = UIImage(resource: .onboardImage2)
        bgImageRight.contentMode = .scaleAspectFill
        bgImageRight.clipsToBounds = true
      
        let labelRight = UILabel()
        labelRight.text = "Даже если это не литры воды и йога"
        labelRight.textAlignment = .center
        labelRight.numberOfLines = 0
        labelRight.textColor = UIColor(named: "YP Black")
        labelRight.font = UIFont.boldSystemFont(ofSize: 32)
        rightController.view.addSubview(bgImageRight)
        rightController.view.addSubview(labelRight)
        labelRight.translatesAutoresizingMaskIntoConstraints = false
        bgImageRight.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgImageRight.leadingAnchor.constraint(equalTo: rightController.view.leadingAnchor),
                    bgImageRight.trailingAnchor.constraint(equalTo: rightController.view.trailingAnchor),
                    bgImageRight.topAnchor.constraint(equalTo: rightController.view.topAnchor),
                    bgImageRight.bottomAnchor.constraint(equalTo: rightController.view.bottomAnchor),
            labelRight.leadingAnchor.constraint(equalTo: rightController.view.leadingAnchor, constant: 16),
            labelRight.trailingAnchor.constraint(equalTo: rightController.view.trailingAnchor, constant: -16),
            labelRight.centerYAnchor.constraint(equalTo: rightController.view.topAnchor, constant: view.bounds.height * 0.58),
        ])
        
        return [leftController, rightController]
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
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
       setupUI()
    }
    
    private func setupUI() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
        
        @objc  func goToNextScreen() {
            let mainVC = TabBarController()
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true)
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
                return nil
            }
            let previousIndex = viewControllerIndex - 1
            guard previousIndex >= 0 else {
                return nil
            }
            return pages[previousIndex]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
                return nil
            }
            let nextIndex = viewControllerIndex + 1
            guard nextIndex < pages.count else {
                return nil
            }
            return pages[nextIndex]
        }
        
       
        // MARK: - UIPageViewControllerDelegate
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
            if let currentViewController = pageViewController.viewControllers?.first,
               let currentIndex = pages.firstIndex(of: currentViewController) {
                pageControl.currentPage = currentIndex
            }
        }
        
    }

