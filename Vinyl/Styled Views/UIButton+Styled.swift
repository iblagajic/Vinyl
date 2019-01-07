//
//  UIButton+Styled.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIButton {
    
    static var camera: UIButton {
        let button = UIButton(forAutoLayout: ())
        button.setImage(.camera, for: .normal)
        button.tintColor = .melon
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.264).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    static var close: UIButton {
        let button = UIButton(forAutoLayout: ())
        button.setImage(.close, for: .normal)
        button.tintColor = .dark
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    static var cancel: UIButton {
        let button = UIButton(forAutoLayout: ())
        button.setBackgroundImage(.cancel, for: .normal)
        button.tintColor = .dark
        button.widthAnchor.constraint(equalToConstant: 77).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    static var back: UIButton {
        let button = UIButton(forAutoLayout: ())
        button.setImage(.back, for: .normal)
        button.tintColor = .dark
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    static var info: UIButton {
        let button = UIButton(forAutoLayout: ())
        button.setImage(.info, for: .normal)
        button.tintColor = .dark
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    static var more: UIButton {
        let button = UIButton(forAutoLayout: ())
        button.setImage(.more, for: .normal)
        button.tintColor = .dark
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
}
