//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Сергей Лебедь on 02.08.2025.
//

import Foundation
struct TrackerCategory {
    let categoryName: String
    let trackers: [Tracker]
    
    init(categoryName: String, trackers: [Tracker]) {
        self.categoryName = categoryName
        self.trackers = trackers
    }
}
    extension TrackerCategory {
        func with(
            categoryName: String? = nil,
            trackers: [Tracker]? = nil
        ) -> TrackerCategory {
            return TrackerCategory(
                categoryName: categoryName ?? self.categoryName,
                trackers: trackers ?? self.trackers
            )
        }
    }

