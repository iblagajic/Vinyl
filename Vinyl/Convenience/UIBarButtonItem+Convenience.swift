//
//  UIBarButtonItem+Convenience.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 07/12/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    static var empty: UIBarButtonItem {
        UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
