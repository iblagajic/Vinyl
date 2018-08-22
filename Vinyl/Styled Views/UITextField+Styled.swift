//
//  UITextField+Styled.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 27/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UITextField {
    
    static var standard: UITextField {
        let textField = PaddedTextField(forAutoLayout: ())
        textField.borderStyle = .none
        textField.font = UIFont.body
        textField.textColor = .dark
        textField.tintColor = .dark
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        let line = UIView.separator
        textField.addSubview(line)
        line.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        line.topAnchor.constraint(equalTo: textField.lastBaselineAnchor, constant: 6).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale).isActive = true
        return textField
    }
    
}

class PaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 6, bottom: 6, right: 0))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 6, bottom: 6, right: 0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 6, bottom: 6, right: 0))
    }
}
