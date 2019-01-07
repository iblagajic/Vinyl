//
//  UIView+Convenience.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift

extension UIView {
    
    static var background: UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        return view
    }
    
    static var separator: UIView {
        let view = UIView(forAutoLayout: ())
        view.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale).isActive = true
        view.backgroundColor = .veryLightPink
        return view
    }
    
}
