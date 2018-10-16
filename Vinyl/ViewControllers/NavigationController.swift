//
//  NavigationController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 02/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    let navigationControllerDelegate = NavigationControllerDelegate()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        delegate = navigationControllerDelegate
        isNavigationBarHidden = true
    }
}
