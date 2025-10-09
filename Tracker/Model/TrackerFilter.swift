//
//  Filters.swift
//  Tracker
//
//  Created by Сергей Лебедь on 07.10.2025.
//

import Foundation
import UIKit
enum TrackerFilter: String, CaseIterable {
    case all = "Все трекеры"
    case today = "На сегодня"
    case completed = "Завершенные"
    case unfinished = "Незавершенные"
        
    var colorButton: UIColor {
        switch self {
        case .all: return UIColor(resource: .ypWhiteOnli)
        case .today: return UIColor(resource: .ypWhiteOnli)
        case .completed: return UIColor(resource: .color1)
        case .unfinished: return UIColor(resource: .color1)
        }
    }
}
