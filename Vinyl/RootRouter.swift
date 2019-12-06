//
//  RootRouter.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 04/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RootRouter {
    
    private let pageControllerDataSource: RootViewControllerDataSource
    private let pageControllerDelegate = RootViewControllerDelegate()
    private let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let rootController: FloatingTabBarController
    private let bag = DisposeBag()
    
    init() {
        let homeViewController = HomeViewController()
        let homeNavigationController = LargeWhiteTitleNavigationController (rootViewController: homeViewController)
        let settingsViewController = SettingsViewController(style: .grouped)
        let settingsNavigationController = LargeWhiteTitleNavigationController(rootViewController: settingsViewController)
        let searchViewController = SearchViewController(collectionViewLayout: VerticalCardsLayout())
        let searchNavigationController = LargeWhiteTitleNavigationController(rootViewController: searchViewController)
        let navigationControllers: [UINavigationController] = [settingsNavigationController, homeNavigationController, searchNavigationController]
        pageControllerDataSource = RootViewControllerDataSource(viewControllers: navigationControllers)
        pageController.dataSource = pageControllerDataSource
        pageController.delegate = pageControllerDelegate
        pageController.setViewControllers([homeNavigationController], direction: .forward, animated: false)
        self.rootController = FloatingTabBarController(pageViewController: pageController)

        var currentViewControllerIndex = 1
        rootController.floatingTabBar.rx.tapped.subscribe(onNext: { [weak self] index in
            let navigationController = navigationControllers[index]
            guard index != currentViewControllerIndex else {
                navigationController.popToRootViewController(animated: true)
                return
            }
            let direction = index < currentViewControllerIndex ? UIPageViewController.NavigationDirection.reverse : .forward
            self?.pageController.setViewControllers([navigationController], direction: direction, animated: true, completion: { completed in
                if completed {
                    currentViewControllerIndex = index
                }
            })
        }).disposed(by: bag)

        let currentPage = pageControllerDelegate.currentPage.share()
        currentPage.map { [weak self] in
            if let navigationController = self?.pageController.viewControllers?.first as? UINavigationController,
                let index = navigationControllers.index(of: navigationController) {
                return index
            } else {
                return 0
            }
        }.subscribe(onNext: { [rootController] selectedIndex in
            rootController.floatingTabBar.select(index: selectedIndex, animated: true)
        }).disposed(by: bag)
    }
}
