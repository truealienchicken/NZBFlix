import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create the main window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Create an instance of StartPageViewController
        let startPageVC = StartPageViewController()
        
        // Wrap the StartPageViewController in a UINavigationController
        let navigationController = UINavigationController(rootViewController: startPageVC)
        
        // Set the UINavigationController as the rootViewController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
