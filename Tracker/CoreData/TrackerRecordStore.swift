import CoreData

final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    
    var onRecordsDidChange: (([TrackerRecord]) -> Void)?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Fetched Results Controller Setup
    private func setupFetchedResultsController() {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false),
            NSSortDescriptor(key: "id", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            notifyRecordsChanged()
        } catch {
            print("Failed to fetch records: \(error)")
        }
    }
    
    private func notifyRecordsChanged() {
        let records = (fetchedResultsController.fetchedObjects ?? []).compactMap { makeRecord(from: $0) }
        onRecordsDidChange?(records)
    }
    
    // MARK: - Public Methods
    
    func fetchAllRecords() throws -> [TrackerRecord] {
        return (fetchedResultsController.fetchedObjects ?? []).compactMap { makeRecord(from: $0) }
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

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notifyRecordsChanged()
    }
}
