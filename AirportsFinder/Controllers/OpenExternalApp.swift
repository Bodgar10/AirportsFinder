//
//  OpenExternalApp.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import UIKit

class OpenExternalApp {
    static public func openAppSettings() {
        OpenExternalApp.openURL(UIApplicationOpenSettingsURLString)
    }
    
    @discardableResult static public func openURL(_ string: String) -> Bool {
        if let url = URL(string: string),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            return true
        } else { return false }
    }
}
