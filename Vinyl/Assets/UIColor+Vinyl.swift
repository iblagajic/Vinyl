//
//  UIColor+Vinyl.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let steelGrey = UIColor(red: 122.0 / 255.0, green: 125.0 / 255.0, blue: 125.0 / 255.0, alpha: 1.0)
    static let veryLightPink = UIColor(white: 205.0 / 255.0, alpha: 1.0)
    static let dark = UIColor(red: 12.0 / 255.0, green: 18.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
    static let dustyOrange = UIColor(red: 1.0, green: 97.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
    static let transparentWhite = UIColor.white.withAlphaComponent(0.2)
    static let lessTransparentWhite = UIColor.white.withAlphaComponent(0.8)
    static let mediumGrey = UIColor(red: 104.0 / 255.0, green: 105.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0)
    static let pale = UIColor(red: 237.0 / 255.0, green: 233.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    static let very = UIColor(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    
}

extension CGColor {

    static let mediumGrey = UIColor.mediumGrey.cgColor
}
