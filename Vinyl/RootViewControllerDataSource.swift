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
        if let index = viewControllers.firstIndex(of: viewController)?.advanced(by: -1),
            viewControllers.indices.contains(index) {
            let previousVC = viewControllers[index]
            previousVC.setNeedsStatusBarAppearanceUpdate()
            return previousVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController)?.advanced(by: 1),
            viewControllers.indices.contains(index) {
            let nextVC = viewControllers[index]
            nextVC.setNeedsStatusBarAppearanceUpdate()
            return nextVC
        }
        return nil
    }
    

}

import RxSwift

class RootViewControllerDelegate: NSObject, UIPageViewControllerDelegate {

    let currentPage = PublishSubject<Void>()

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            pageViewController.setNeedsStatusBarAppearanceUpdate()
        }
        currentPage.onNext(())
    }
}
