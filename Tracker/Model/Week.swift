//
//  Week.swift
//  Tracker
//
//  Created by Сергей Лебедь on 02.08.2025.
//

import Foundation
enum WeekDay: String, CaseIterable, Codable {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
}
extension Date {
    func weekDay() -> WeekDay {
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: self)
        
        switch weekdayNumber {
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        case 1: return .sunday
        default: return .monday
        }
    }
}
