import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {
    
    func testMainScreen() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(of: vc, as: .image, named: "main_screen", record: false)
    }
    
    func testMainScreenLightMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), named: "main_screen_light", record: false)
    }
    
    func testMainScreenWithDatePickerExpanded() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(of: vc, as: .image, named: "main_screen_date_picker", record: false)
    }
    
    func testMainScreenEmptyState() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(of: vc, as: .image, named: "main_screen_empty", record: false)
    }
    
    func testMainScreenWithTrackers() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(of: vc, as: .image, named: "main_screen_with_trackers", record: false)
    }
    
    func testMainScreenAccessibilityLargeText() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(preferredContentSizeCategory: .accessibilityLarge)),
            named: "main_screen_large_text",
            record: false
        )
    }
}
