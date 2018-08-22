//
//  UIViewController+Helper.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 22/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var rootPresenter: UIViewController {
        guard let presenter = presentingViewController else {
            return self
        }
        return presenter.rootPresenter
    }
    
}
