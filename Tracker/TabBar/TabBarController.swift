//
//  TabBarController.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import UIKit
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let trackersVC = TrackersViewController()
        trackersVC.tabBarItem = UITabBarItem(title: "Трекеры",
                                                         image: UIImage(named: "trackers"),
                                                         selectedImage: nil)
        let statsVC = StatsViewController()
        statsVC.tabBarItem = UITabBarItem(title: "Статистика",
                                                      image: UIImage(named: "stats"),
                                                      selectedImage: nil)
        let trackersNavVC = UINavigationController(rootViewController: trackersVC)
        let statsNavVC = UINavigationController(rootViewController: statsVC)
        self.viewControllers = [trackersNavVC, statsNavVC]
    }
    
}
