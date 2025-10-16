//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Сергей Лебедь on 09.10.2025.
//

import Foundation
import AppMetricaCore

struct AnalyticsService {
    // MARK: - Enums
       
       enum Event: String {
           case open
           case close
           case click
       }
       
       enum Screen: String {
           case main = "Main"
           case statistics = "Statistics"
           case onboarding = "Onboarding"
           case category = "Category"
       }
       
       enum Item: String {
           case addTrack = "add_track"
           case track = "track"
           case filter = "filter"
           case edit = "edit"
           case delete = "delete"
       }
       
       // MARK: - Activation
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "ad5e22e3-c9d7-48b1-95ed-69308bfef759") else { return }

        AppMetrica.activate(with: configuration)
    }
    static func reportEvent(event: Event, screen: Screen, item: Item? = nil) {
        var params: [AnyHashable: Any] = ["screen": screen.rawValue]
        
        if event == .click, let item = item {
            params["item"] = item.rawValue
        }
        print("AnalyticsService: отправка события: \(event.rawValue), параметры: \(params)")
        AppMetrica.reportEvent(name: event.rawValue, parameters: params) { error in
            print("❌ Ошибка при отправке события в AppMetrica: \(error.localizedDescription)")
        }
    }
}
