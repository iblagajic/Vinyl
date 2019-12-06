//
//  RoundedButton.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 02/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lessTransparentWhite : .transparentWhite
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(frame.width, frame.height)/2
        adjustsImageWhenHighlighted = false
    }
}
