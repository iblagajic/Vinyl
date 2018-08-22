//
//  ActivityIndicatorView.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 01/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIImageView {
    
    convenience init() {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rotate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rotate()
    }
    
    private func rotate() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: { [weak self] in
            guard let `self` = self else { return }
            self.transform = self.transform.rotated(by: .pi)
        }) { [weak self] _ in
            self?.rotate()
        }
    }
    
}
