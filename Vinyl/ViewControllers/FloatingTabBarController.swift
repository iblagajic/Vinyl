//
//  FloatingTabBarController.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 30/09/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class FloatingTabBarController: UIViewController {
    let pageViewController: UIPageViewController
    let floatingTabBar: FloatingTabBar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return pageViewController.viewControllers?.first?.preferredStatusBarStyle ?? .default
    }

    init(pageViewController: UIPageViewController) {
        self.pageViewController = pageViewController
        self.floatingTabBar = FloatingTabBar(with: [UITabBarItem(title: nil, image: UIImage(named: "settings"), tag: 0),
                                                    UITabBarItem(title: nil, image: UIImage(named: "home"), tag: 1),
                                                    UITabBarItem(title: nil, image: UIImage(named: "search"), tag: 2)])
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        view.addSubview(floatingTabBar)

        pageViewController.view.pinToSuperview()
        NSLayoutConstraint.activate([
            floatingTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -11),
            floatingTabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
