//
//  CustomActionSheetCell.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 08/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class CustomActionSheetCell: UITableViewCell {
    
    let label = UILabel.header
    let icon = UIImageView(forAutoLayout: ())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func update(option: ActionSheetOption) {
        label.text = option.title
        icon.image = option.iconImage
    }
    
    private func setup() {
        [label, icon].forEach(addSubview)
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 28),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            icon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        backgroundColor = .clear
        icon.tintColor = .dark
        selectionStyle = .none
    }
}
