//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Сергей Лебедь on 30.09.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker
final class TrackerTests: XCTestCase {

   
    func testViewControllerLight() {
        let tabController = TabBarController()
        assertSnapshot(of: tabController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    func testViewControllerDark() {
        let tabController = TabBarController()
        assertSnapshot(of: tabController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
