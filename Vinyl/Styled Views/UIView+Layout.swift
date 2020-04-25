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
    
    func pinToSuperview(anchors: UIRectEdge = .all, withInsets insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("Can't set constraints to a view which has no superview")
        }
        pin(anchors: anchors, to: superview, withInsets: insets)
    }
    
    func pin(anchors: UIRectEdge = .all,to view: UIView, withInsets insets: UIEdgeInsets = .zero) {
        if anchors.contains(.left) {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        }
        if anchors.contains(.top) {
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        }
        if anchors.contains(.right) {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
        }
        if anchors.contains(.bottom) {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
        }
    }
    
    func centerInSuperview() {
        guard let superview = superview else {
            fatalError("Can't set constraints to a view which has no superview")
        }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
}
