import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        showLaunchScreen()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showMainApp()
        }
    }
    
    private func showLaunchScreen() {
        let launchScreenVC = LaunchScreenViewController()
        window?.rootViewController = launchScreenVC
        window?.makeKeyAndVisible()
    }
    
    private func showMainApp() {
        let tabBarController = TabBarController()
        
        UIView.transition(with: window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.window?.rootViewController = tabBarController
        },
                          completion: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
