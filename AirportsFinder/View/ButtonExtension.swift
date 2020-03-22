//
//  ButtonExtension.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import UIKit

class ButtonExtension: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var shadow : Bool = false {
        didSet {
            if shadow {
                layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
                layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                layer.shadowOpacity = 3.0
                layer.shadowRadius = 5.0
            }
        }
    }
}
