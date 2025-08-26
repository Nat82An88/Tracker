import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        addTabBarSeparator()
    }
    
    private func setupTabBar() {
        let trackersNavVC = UINavigationController(rootViewController: TrackersViewController())
        let statisticsVC = StatisticsViewController()
        
        trackersNavVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tracker_logo"),
            selectedImage: nil
        )
        
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statistic_logo"),
            selectedImage: nil
        )
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .kern: -0.24
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        statisticsVC.tabBarItem.isEnabled = false
        
        viewControllers = [trackersNavVC, statisticsVC]
        
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .ypBlue
        
        DispatchQueue.main.async {
            self.adjustTabBarHeight()
        }
    }
    
    private func addTabBarSeparator() {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: tabBar.topAnchor),
            separator.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
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
