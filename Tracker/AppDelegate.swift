import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Store Properties
    private(set) lazy var trackerCategoryStore: TrackerCategoryStore = {
        TrackerCategoryStore(context: CoreDataManager.shared.viewContext)
    }()
    
    private(set) lazy var trackerStore: TrackerStore = {
        TrackerStore(context: CoreDataManager.shared.viewContext)
    }()
    
    private(set) lazy var trackerRecordStore: TrackerRecordStore = {
        TrackerRecordStore(context: CoreDataManager.shared.viewContext)
    }()
    
    // MARK: - App Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "hasPreloadedData") {
            defaults.set(true, forKey: "hasPreloadedData")
        }
        
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
}
