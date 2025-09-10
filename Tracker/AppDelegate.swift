import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print("Database URL: \(storeDescription.url?.absoluteString ?? "unknown")")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // MARK: - Store Properties
    private(set) lazy var trackerCategoryStore: TrackerCategoryStore = {
        TrackerCategoryStore(context: persistentContainer.viewContext)
    }()
    
    private(set) lazy var trackerStore: TrackerStore = {
        TrackerStore(context: persistentContainer.viewContext)
    }()
    
    private(set) lazy var trackerRecordStore: TrackerRecordStore = {
        TrackerRecordStore(context: persistentContainer.viewContext)
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
