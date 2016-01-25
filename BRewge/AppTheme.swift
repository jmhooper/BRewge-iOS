import UIKit

public struct AppTheme {
    
    public static func setAppTheme() {
        setNavigationBarTheme()
    }
    
    private static func setNavigationBarTheme() {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor.blackColor()
        appearance.translucent = false
        appearance.tintColor = UIColor.whiteColor()
        appearance.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
    }
    
}