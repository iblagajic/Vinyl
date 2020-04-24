//
//  UIButton+Styled.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIButton {
    
    static var settings: UIButton {
        let button = RoundedButton(forAutoLayout: ())
        button.setImage(.settings, for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 55).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    static var search: UIButton {
        let button = RoundedButton(forAutoLayout: ())
        button.setImage(.search, for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 55).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    static var scan: UIButton {
        let button = RoundedButton(forAutoLayout: ())
        button.setImage(.scan, for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 121).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
}
