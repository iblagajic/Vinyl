//
//  UIPageViewControllerDataSource.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 04/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class RootViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    private let viewControllers: [UIViewController]
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.index(of: viewController)?.advanced(by: -1),
            viewControllers.indices.contains(index) {
            return viewControllers[index]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.index(of: viewController)?.advanced(by: 1),
            viewControllers.indices.contains(index) {
            return viewControllers[index]
        }
        return nil
    }
    
    
}
