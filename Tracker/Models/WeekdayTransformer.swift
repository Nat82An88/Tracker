import Foundation

@objc(WeekdayArrayTransformer)
final class WeekdayArrayTransformer: ValueTransformer {
    
    static let name = NSValueTransformerName("WeekdayArrayTransformer")
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let weekdays = value as? [Weekday] else { return nil }
        
        do {
            let data = try JSONEncoder().encode(weekdays)
            return data as NSData
        } catch {
            print("Error transforming weekdays: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let weekdays = try JSONDecoder().decode([Weekday].self, from: data)
            return weekdays
        } catch {
            print("Error reverse transforming weekdays: \(error)")
            return nil
        }
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            WeekdayArrayTransformer(),
            forName: name
        )
    }
}
