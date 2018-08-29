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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        [positionLabel, titleLabel, durationLabel].forEach(addSubview)
        
        positionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        positionLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
        positionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 11).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        durationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 22).isActive = true
        durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        durationLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        backgroundColor = .clear
        titleLabel.numberOfLines = 1
        durationLabel.numberOfLines = 1
    }
}
