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
    
    init(id: UUID = UUID(), name: String, emoji: String, color: String, timeTable: [WeekDay]) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.timeTable = timeTable
    }
    static func newTracker(name: String,
                           emoji: String,
                           color: String,
                           timeTable: [WeekDay]) -> Tracker {
        return Tracker(id: UUID(),
                       name: name,
                       emoji: emoji,
                       color: color,
                       timeTable: timeTable)
    }
}

