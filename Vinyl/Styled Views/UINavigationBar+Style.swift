//
//  UINavigationBar+Style.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 04/02/2020.
//  Copyright © 2020 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UINavigationBar {

    func set(backgroundColor: UIColor) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = backgroundColor
            standardAppearance = appearance
        } else {
            self.backgroundColor = backgroundColor
        }
    }
}
