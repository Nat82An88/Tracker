import XCTest
import SnapshotTesting
@testable import Tracker

final class SnapshotValidationTest: XCTestCase {
    
    func testSnapshotFailsWhenBackgroundChanges() {
        // Given
        let vc = TrackersViewController()
        vc.loadViewIfNeeded()
        
        // When:
        vc.view.backgroundColor = .systemRed
        
        // Then: тест ДОЛЖЕН провалиться (это проверка что тесты работают)
        assertSnapshot(of: vc, as: .image, named: "should_fail_with_red_background", record: false)
    }
    
    func testSnapshotFailsWhenTitleChanges() {
        // Given
        let vc = TrackersViewController()
        vc.loadViewIfNeeded()
        
        // When:
        vc.title = "Измененный заголовок"
        
        // Then: тест ДОЛЖЕН провалиться
        assertSnapshot(of: vc, as: .image, named: "should_fail_with_changed_title", record: false)
    }
}
