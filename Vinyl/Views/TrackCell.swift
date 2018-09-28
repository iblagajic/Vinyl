//
//  TrackCell.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 22/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    
    let positionLabel = UILabel.position
    let titleLabel = UILabel.body
    let durationLabel = UILabel.bodyLight
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        [positionLabel, titleLabel, durationLabel].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            positionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            positionLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 11),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            durationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 22),
            durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            durationLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        durationLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        backgroundColor = .clear
        titleLabel.numberOfLines = 1
        durationLabel.numberOfLines = 1
    }
}
