import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {
    
    func testMainScreenLightMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light)),
            named: "main_screen_light",
            record: false
        )
    }
    
    func testMainScreenDarkMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark)),
            named: "main_screen_dark",
            record: false
        )
    }
    
    func testMainScreenWithDatePickerExpandedLightMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light)),
            named: "main_screen_date_picker_light",
            record: false
        )
    }
    
    func testMainScreenWithDatePickerExpandedDarkMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark)),
            named: "main_screen_date_picker_dark",
            record: false
        )
    }
    
    func testMainScreenEmptyStateLightMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light)),
            named: "main_screen_empty_light",
            record: false
        )
    }
    
    func testMainScreenEmptyStateDarkMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark)),
            named: "main_screen_empty_dark",
            record: false
        )
    }
    
    func testMainScreenWithTrackersLightMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light)),
            named: "main_screen_with_trackers_light",
            record: false
        )
    }
    
    func testMainScreenWithTrackersDarkMode() {
        // Given
        let vc = TrackersViewController()
        
        // When
        vc.loadViewIfNeeded()
        
        // Then
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark)),
            named: "main_screen_with_trackers_dark",
            record: false
        )
    }
}
