//
//  UserDefaults.swift
//  Tracker
//
//  Created by Сергей Лебедь on 26.07.2025.
//

import Foundation

extension UserDefaults {
    static var isFirstLaunch: Bool {
        get { !standard.bool(forKey: "isFirstLaunch") }
        set { standard.set(!newValue, forKey: "isFirstLaunch") }
    }
}
