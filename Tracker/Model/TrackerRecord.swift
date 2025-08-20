//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Сергей Лебедь on 02.08.2025.
//

import Foundation
struct TrackerRecord {
    let trackerId: Tracker.ID
    let date: Date
    init(id: Tracker.ID, date: Date) {
        self.trackerId = id
        self.date = date
    }
}

