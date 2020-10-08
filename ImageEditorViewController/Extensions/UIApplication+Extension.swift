//
//  UIApplication+Extension.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 08/10/20.
//
import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    class func topViewControllerForPersentation(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if let navigationController = controller as? UINavigationController {
            return navigationController
        } else if let tabController = controller as? UITabBarController {
            return tabController
        }
        return controller
    }
}
