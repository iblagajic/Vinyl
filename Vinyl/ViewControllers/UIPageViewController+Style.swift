//
//  UIPageViewController+Style.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 04/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIPageViewController {
    open override var childForStatusBarStyle: UIViewController? {
        return viewControllers?.first
    }
}
