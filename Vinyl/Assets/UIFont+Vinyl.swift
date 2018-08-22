//
//  UIFont+Vinyl.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func regularFont(with size: CGFloat) -> UIFont? {
        return UIFont(name: "Optima-Regular", size: size)
    }
    
    static func boldFont(with size: CGFloat) -> UIFont? {
        return UIFont(name: "Optima-Bold", size: size)
    }
    
    static var block = UIFont.boldFont(with: 44)
    static var header = UIFont.regularFont(with: 24)
    static var headerBold = UIFont.boldFont(with: 24)
    static var header2 = UIFont.boldFont(with: 20)
    static var header3 = UIFont.regularFont(with: 20)
    static var subheader = UIFont.regularFont(with: 18)
    static var body = UIFont.regularFont(with: 16)
    static var bodyBold = UIFont.boldFont(with: 16)
    
}
