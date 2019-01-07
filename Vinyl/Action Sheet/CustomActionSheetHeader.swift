//
//  CustomActionSheetHeader.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 08/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class CustomActionSheetHeader: UIView {
    let closeButton = UIButton.close
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
            closeButton.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
