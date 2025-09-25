import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Properties
    private var pages: [UIViewController] = []
    private let initialPage = 0
    
    // MARK: - Constants
    private enum Constants {
        static let pageControlBottomOffset: CGFloat = -134
    }
    
    // MARK: - UI Elements
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        pageControl.currentPageIndicatorTintColor = .ypBlackDay
        pageControl.pageIndicatorTintColor = .ypGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - Initialization
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true)
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.pageControlBottomOffset),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    func completeOnboarding() {
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
        
        return currentIndex == 0 ? pages.last : pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        return currentIndex == pages.count - 1 ? pages.first : pages[currentIndex + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController) else { return }
        pageControl.currentPage = currentIndex
    }
}
