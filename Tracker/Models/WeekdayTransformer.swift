import Foundation

@objc(WeekdayArrayTransformer)
final class WeekdayArrayTransformer: ValueTransformer {
    
    static let name = NSValueTransformerName("WeekdayArrayTransformer")
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let weekdays = value as? [Weekday] else { return nil }
        return weekdays.map { $0.rawValue } as NSArray
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let intArray = value as? [Int] else { return nil }
        return intArray.compactMap { Weekday(rawValue: $0) }
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            WeekdayArrayTransformer(),
            forName: name
        )
    }
}
