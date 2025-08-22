import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let trackersNavVC = UINavigationController(rootViewController: TrackersViewController())
        let statisticsVC = StatisticsViewController()
        
        // Setting up tabs
        trackersNavVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tracker_logo"),
            selectedImage: nil
        )
        
        statisticsVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "statistic_logo"),
            selectedImage: nil
        )
        
        statisticsVC.tabBarItem.isEnabled = false
        
        viewControllers = [trackersNavVC, statisticsVC]
        
        // Configuring TabBar appearance
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .ypBlue
        
        DispatchQueue.main.async {
            self.adjustTabBarHeight()
        }
    }
    
    private func adjustTabBarHeight() {
        let newHeight: CGFloat = 84
        var newFrame = tabBar.frame
        newFrame.size.height = newHeight
        newFrame.origin.y = view.frame.size.height - newHeight
        tabBar.frame = newFrame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTabBarHeight()
    }
}
