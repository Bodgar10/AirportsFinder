//
//  AlertFactory.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import UIKit

class AlertFactory {
    static public func simpleWith(title         : String? = "Airport",
                                  message       : String?,
                                  actionTitle   : String = "Aceptar",
                                  actionHandler : ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title           : title,
                                                message         : message,
                                                preferredStyle  :  .alert)
        alertController.addAction(UIAlertAction(title   : actionTitle,
                                                style   : .default,
                                                handler : actionHandler))
        return alertController
    }
    
    static public func doubleWith(title                 : String? = "Airport",
                                  message               : String?,
                                  firstActionTitle      : String = "Cancelar",
                                  firstActionHandler    : ((UIAlertAction) -> Void)? = nil,
                                  secondActionTitle     : String = "Aceptar",
                                  secondActionHandler   : ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = AlertFactory.simpleWith(title: title, message: message, actionTitle: firstActionTitle, actionHandler: firstActionHandler)
        alertController.addAction(UIAlertAction(title   : secondActionTitle,
                                                style   : .default,
                                                handler : secondActionHandler))
        return alertController
    }
    
    static public func sendToSettings(cancelAction: (()->())? = nil) {
        UIApplication.shared
            .keyWindow?
            .rootViewController?
            .topMostViewController
            .present(AlertFactory.simpleWith(message: "Para usar la aplicación es necesario activar tu ubicación desde la configuración del dispositivo.",
                                             actionTitle: "Ir a la Configuración",
                                             actionHandler: { (_) in
                                                OpenExternalApp.openAppSettings()
        }), animated: true)
    }
}

extension UIViewController {
    public var topMostViewController: UIViewController {
        if let presented  = presentedViewController         { return presented .topMostViewController }
        if let navigation = self as? UINavigationController { return navigation.visibleViewController? .topMostViewController ?? navigation }
        if let tabBar     = self as? UITabBarController     { return tabBar    .selectedViewController?.topMostViewController ?? tabBar }
        return self
    }
}
