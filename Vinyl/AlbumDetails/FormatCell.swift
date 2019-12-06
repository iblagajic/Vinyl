//
//  FormatCell.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 01/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

enum FormatCellType {
    case format(String)
    case date(String)
}

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
    func update(with formatCellType: FormatCellType) {
        switch formatCellType {
        case .format(let formatTitle):
            titleLabel.text = formatTitle
            backgroundColor = .dustyOrange
        case .date(let dateString):
            titleLabel.text = dateString
            backgroundColor = .mediumGrey
        }
    }
    
    private func setup() {
        addSubview(titleLabel)
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.pinToSuperview(withInsets: UIEdgeInsets(top: 0, left: 11, bottom: 0, right: -11))
    }
}
