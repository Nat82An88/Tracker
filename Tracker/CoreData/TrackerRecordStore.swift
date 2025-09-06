import CoreData

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func fetchAllRecords() throws -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let recordsCoreData = try context.fetch(request)
        return recordsCoreData.compactMap { makeRecord(from: $0) }
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        let recordCoreData = TrackerRecordCoreData(context: context)
        updateRecord(recordCoreData, with: record)
        try context.save()
    }
    
    func removeRecord(with id: UUID, date: Date) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", id as CVarArg, date as CVarArg)
        
        let records = try context.fetch(request)
        records.forEach { context.delete($0) }
        try context.save()
    }
    
    func fetchRecords(for trackerId: UUID) throws -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        
        let recordsCoreData = try context.fetch(request)
        return recordsCoreData.compactMap { makeRecord(from: $0) }
    }
    
    func isTrackerCompleted(_ trackerId: UUID, on date: Date) throws -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerId as CVarArg, date as CVarArg)
        
        return try context.count(for: request) > 0
    }
    
    func completionCount(for trackerId: UUID) throws -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        
        return try context.count(for: request)
    }
    
    // MARK: - Private Methods
    
    private func makeRecord(from coreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard let id = coreData.id, let date = coreData.date else {
            return nil
        }
        
        return TrackerRecord(id: id, date: date)
    }
    
    private func updateRecord(_ recordCoreData: TrackerRecordCoreData, with record: TrackerRecord) {
        recordCoreData.id = record.id
        recordCoreData.date = record.date
    }
}
