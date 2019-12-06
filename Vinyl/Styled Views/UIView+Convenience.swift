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
        view.backgroundColor = .melon
        return view
    }
    
    static var whiteBackground: UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        return view
    }
    
    static var empty: UIView {
        let view = UIView(forAutoLayout: ())
        view.backgroundColor = .clear
        return view
    }
    
    static var separator: UIView {
        let view = UIView(forAutoLayout: ())
        view.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale).isActive = true
        view.backgroundColor = .veryLightPink
        return view
    }
    
    func setShadow(color: CGColor = .mediumGrey, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 11, opacity: Float = 0.2) {
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}
