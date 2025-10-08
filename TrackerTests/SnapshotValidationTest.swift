import XCTest
import SnapshotTesting
@testable import Tracker

final class SnapshotValidationTest: XCTestCase {
    
    func testSnapshotFailsWhenBackgroundChangesLightMode() {
        // Given
        let vc = TrackersViewController()
        vc.loadViewIfNeeded()
        
        // When:
        vc.view.backgroundColor = .systemRed
        
        // Then: тест ДОЛЖЕН провалиться (это проверка что тесты работают)
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light)),
            named: "should_fail_with_red_background_light",
            record: false
        )
    }
    
    func testSnapshotFailsWhenBackgroundChangesDarkMode() {
        // Given
        let vc = TrackersViewController()
        vc.loadViewIfNeeded()
        
        // When:
        vc.view.backgroundColor = .systemRed
        
        // Then: тест ДОЛЖЕН провалиться (это проверка что тесты работают)
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark)),
            named: "should_fail_with_red_background_dark",
            record: false
        )
    }
    
    func testSnapshotFailsWhenTitleChangesLightMode() {
        // Given
        let vc = TrackersViewController()
        vc.loadViewIfNeeded()
        
        // When:
        vc.title = "Измененный заголовок"
        
        // Then: тест ДОЛЖЕН провалиться
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light)),
            named: "should_fail_with_changed_title_light",
            record: false
        )
    }
    
    func testSnapshotFailsWhenTitleChangesDarkMode() {
        // Given
        let vc = TrackersViewController()
        vc.loadViewIfNeeded()
        
        // When:
        vc.title = "Измененный заголовок"
        
        // Then: тест ДОЛЖЕН провалиться
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark)),
            named: "should_fail_with_changed_title_dark",
            record: false
        )
    }
}
