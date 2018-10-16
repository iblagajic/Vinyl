//
//  FormatCell.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 01/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class FormatCell: UICollectionViewCell {
    
    let titleLabel = UILabel.format
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        heightAnchor.constraint(equalToConstant: 29).isActive = true
        titleLabel.pinToSuperview(withInsets: UIEdgeInsets(top: 0, left: 11, bottom: 0, right: -11))
        backgroundColor = .melon
        layer.cornerRadius = 11
    }
}
