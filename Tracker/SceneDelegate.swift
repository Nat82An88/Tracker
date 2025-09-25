import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let onboardingShown = UserDefaults.standard.bool(forKey: "onboardingShown")
        
        if onboardingShown {
            showMainApp()
        } else {
            showOnboarding()
        }
        
        window?.makeKeyAndVisible()
    }
    
    private func showOnboarding() {
        let onboardingVC = OnboardingPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        window?.rootViewController = onboardingVC
    }
    
    private func showMainApp() {
        let tabBarController = TabBarController()
        
        UIView.transition(with: window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.window?.rootViewController = tabBarController
        }, completion: nil)
    }
    
    private func showLaunchScreenImmediately() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchScreenVC = storyboard.instantiateInitialViewController()
        
        window?.rootViewController = launchScreenVC
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
