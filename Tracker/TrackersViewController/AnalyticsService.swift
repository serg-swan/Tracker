//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Сергей Лебедь on 09.10.2025.
//

import Foundation
import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "ad5e22e3-c9d7-48b1-95ed-69308bfef759") else { return }

        AppMetrica.activate(with: configuration)
    }
    static func reportEvent(event: String, screen: String, item: String? = nil) {
        var params: [AnyHashable: Any] = ["screen": screen]
        
        if event == "click", let item = item {
            params["item"] = item
        }
        print("AnalyticsService: отправка события: \(event), параметры: \(params)")
        AppMetrica.reportEvent(name: event, parameters: params) { error in
            print("❌ Ошибка при отправке события в AppMetrica: \(error.localizedDescription)")
        }
    }
}
