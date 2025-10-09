//
//  Tracker.swift
//  Tracker
//
//  Created by Сергей Лебедь on 02.08.2025.
//
import UIKit

struct Tracker: Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let color: String
    let timeTable: [WeekDay]
    let category: String
    let record: Int?
    let recordDates: [Date]?
    
    init(id: UUID = UUID(), name: String, emoji: String, color: String, timeTable: [WeekDay], category: String, record: Int?, recordDates: [Date]?) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.timeTable = timeTable
        self.category = category
        self.record = record
        self.recordDates = recordDates
    }
    static func newTracker(name: String,
                           emoji: String,
                           color: String,
                           timeTable: [WeekDay],
                           category: String,
                           record: Int? = nil) -> Tracker {
        return Tracker(id: UUID(),
                       name: name,
                       emoji: emoji,
                       color: color,
                       timeTable: timeTable,
                       category: category,
                    record: nil,
        recordDates: nil)
    }
}

