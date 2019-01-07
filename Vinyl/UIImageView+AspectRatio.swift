//
//  UIImageView+Ratio.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 10/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func constraintToKeepAspectRatio(of image: UIImage) -> NSLayoutConstraint {
        let multiplier = image.size.width/image.size.height
        let ratio = widthAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier)
        ratio.isActive = true
        return ratio
    }
}
