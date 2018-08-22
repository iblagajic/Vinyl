//
//  UIView+Layout.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(forAutoLayout: ()) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinToSuperview(withInsets insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("Can't set constraints to a view which has no superview")
        }
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom).isActive = true
    }
    
    func pin(to view: UIView, withInsets insets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
    }
    
    func centerInSuperview() {
        guard let superview = superview else {
            fatalError("Can't set constraints to a view which has no superview")
        }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
}
