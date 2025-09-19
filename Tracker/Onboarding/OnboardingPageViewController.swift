import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Properties
    private var pages: [UIViewController] = []
    private let pageControl = UIPageControl()
    private let initialPage = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupPageControl()
    }
    
    // MARK: - Setup Methods
    private func setupPageViewController() {
        dataSource = self
        delegate = self
        
        // Create onboarding pages
        let firstPage = OnboardingViewController(
            backgroundImage: UIImage(resource: .backgroundFirst),
            title: "Отслеживайте только\nто, что хотите",
            buttonTitle: "Вот это технологии!"
        )
        
        let secondPage = OnboardingViewController(
            backgroundImage: UIImage(resource: .backgroundSecond),
            title: "Даже если это\nне литры воды и йога",
            buttonTitle: "Вот это технологии!"
        )
        
        pages = [firstPage, secondPage]
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupPageControl() {
        pageControl.currentPage = initialPage
        pageControl.numberOfPages = pages.count
        pageControl.currentPageIndicatorTintColor = .ypBlackDay
        pageControl.pageIndicatorTintColor = .ypGray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Button Action
    @objc func buttonTapped() {
        UserDefaults.standard.set(true, forKey: "onboardingShown")
        
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        return currentIndex > 0 ? pages[currentIndex - 1] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        return currentIndex < pages.count - 1 ? pages[currentIndex + 1] : nil
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers,
              let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
}
