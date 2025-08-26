//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Сергей Лебедь on 23.08.2025.
//

import Foundation
import CoreData

public final class TrackerCategoryStore {
    public let container: NSPersistentContainer
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }
}
