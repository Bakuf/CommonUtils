
import UIKit

public struct CommonUtils {}

//Math related
public extension CommonUtils {
    
    static func calculatePercent(value: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat{
        if start == end { return 1.0 }
        let diff = value - start
        let scope = end - start
        var progress : CGFloat = 0.0
        if(diff != 0.0) {
            progress = diff / scope
        } else {
            progress = 0.0
        }
        return progress;
    }
    
    static func lerp(v0: CGFloat, v1: CGFloat, time: CGFloat) -> CGFloat {
        return (1.0 - time) * v0 + time * v1;
    }
    
    static func clamp<T>(_ value: T, minValue: T, maxValue: T) -> T where T : Comparable {
        return min(max(value, minValue), maxValue)
    }
    
}

//Time related
public extension CommonUtils {
    
    static func hmsFrom(seconds: Int) -> (hours: Int,minutes: Int,seconds: Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

//UI Related
public extension CommonUtils {
    
    ///Set to true if you want to see layout issues logs, false to hide them
    static func setLayoutUnsatisfiableLog(enabled: Bool) {
        UserDefaults.standard.setValue(enabled, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    static var currentKeyWindow : UIWindow? {
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if window != nil {
            return window
        }
        return UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    }
    
    static func topViewController(rootViewControler: UIViewController? = nil) -> UIViewController {
        var rootVC = rootViewControler
        if rootVC == nil {
            rootVC = currentKeyWindow?.rootViewController
        }
        guard let rootVC = rootVC else {
            fatalError()
        }
        guard let presentedViewController = rootVC.presentedViewController else {
            return rootVC
        }
        if let navVC = presentedViewController as? UINavigationController,
            let lastVC = navVC.viewControllers.last {
            return topViewController(rootViewControler: lastVC)
        }
        return topViewController(rootViewControler: presentedViewController)
    }
    
    static var safeAreaInsets : UIEdgeInsets{
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        return keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    static var currentOSUserInterfaceStyle : UIUserInterfaceStyle {
        UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    static var isIPhone : Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isIpad : Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
