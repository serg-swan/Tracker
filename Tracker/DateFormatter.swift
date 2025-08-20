//
//  DateFormatter.swift
//  Tracker
//
//  Created by Сергей Лебедь on 27.07.2025.
//

import Foundation

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
}
