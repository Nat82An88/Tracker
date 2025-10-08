import Foundation
import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: Constants.appMetricaKey) else { return }
        
        AppMetrica.activate(with: configuration)
    }
    
    func report(_ event: AnalyticsEvent) {
        AppMetrica.reportEvent(
            name: event.name,
            parameters: event.params,
            onFailure: { error in
                print("REPORT ERROR: %@", error.localizedDescription)
            }
        )
        
        print("Analytics Event: \(event.name) - \(event.params)")
    }
}

private enum Constants {
    static let appMetricaKey = "d91cb00a-e366-4b0a-bb56-ed5e6b4bce67"
}
