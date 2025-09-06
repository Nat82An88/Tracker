import CoreData

final class TrackerStore {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func fetchAllTrackers() throws -> [Tracker] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackersCoreData = try context.fetch(request)
        return trackersCoreData.compactMap { makeTracker(from: $0) }
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        let existingCategories = try context.fetch(request)
        let category: TrackerCategoryCoreData
        
        if let existingCategory = existingCategories.first {
            category = existingCategory
        } else {
            category = TrackerCategoryCoreData(context: context)
            category.title = categoryTitle
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        updateTracker(trackerCoreData, with: tracker)
        
        if let existingTrackers = category.trackers as? Set<TrackerCoreData> {
            var updatedTrackers = existingTrackers
            updatedTrackers.insert(trackerCoreData)
            category.trackers = NSSet(set: updatedTrackers)
        } else {
            category.trackers = NSSet(array: [trackerCoreData])
        }
        
        try context.save()
    }
    
    // MARK: - Private Methods
    
    private func makeTracker(from coreData: TrackerCoreData) -> Tracker? {
        guard let id = coreData.id,
              let title = coreData.title,
              let color = coreData.color,
              let emoji = coreData.emoji else {
            return nil
        }
        
        var schedule: [Weekday] = []
        if let scheduleArray = coreData.schedule as? [Int] {
            schedule = scheduleArray.compactMap { Weekday(rawValue: $0) }
        }
        
        return Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule,
            isHabit: coreData.isHabit
        )
    }
    
    private func updateTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.isHabit = tracker.isHabit
        
        let scheduleArray = tracker.schedule.map { $0.rawValue } as NSArray
        trackerCoreData.schedule = scheduleArray
    }
}
