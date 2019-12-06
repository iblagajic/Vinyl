//
//  LargeTitleNavigationController.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 05/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class LargeTitleNavigationController: UINavigationController {
    
    var titleColor: UIColor = .white {
        didSet {
            navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.largeTitle,
                                                      NSAttributedString.Key.foregroundColor : titleColor]
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return viewControllers.first?.preferredStatusBarStyle ?? .default
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        titleColor = .dark
        navigationBar.tintColor = .dark
        navigationBar.barTintColor = .white
        navigationBar.prefersLargeTitles = true
    }
}
