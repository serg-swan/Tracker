//
//  TabBarController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import UIKit
final class TabBarController: UITabBarController {
    private let topBorder = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBorder()
        
        let trackersVC = TrackersViewController()
        let trackersString = NSLocalizedString("trackers", comment: "")
        trackersVC.tabBarItem = UITabBarItem(title: trackersString,
                                             image: UIImage(resource: .trackers),
                                                         selectedImage: nil)
        let statsVC = StatsViewController()
        let modelRecord = TrackerRecordDataProvider()
        let model = TrackerCategoryDataProvider()
        let viewModel = ViewModel(for: model, modelRecord: modelRecord)
        statsVC.initialize(viewModel: viewModel)
        let statisticsString = NSLocalizedString("statistics", comment: "")
        statsVC.tabBarItem = UITabBarItem(title: statisticsString,
                                          image: UIImage(resource: .stats),
                                                      selectedImage: nil)
        let trackersNavVC = UINavigationController(rootViewController: trackersVC)
        let statsNavVC = UINavigationController(rootViewController: statsVC)
        self.viewControllers = [trackersNavVC, statsNavVC]
    }
    
    private func setupTopBorder() {
           topBorder.backgroundColor = .separator // Системный цвет разделителя
           topBorder.translatesAutoresizingMaskIntoConstraints = false
           tabBar.addSubview(topBorder)
           
           NSLayoutConstraint.activate([
               topBorder.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
               topBorder.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
               topBorder.topAnchor.constraint(equalTo: tabBar.topAnchor),
               topBorder.heightAnchor.constraint(equalToConstant: 0.5)
           ])
       }
    
}
