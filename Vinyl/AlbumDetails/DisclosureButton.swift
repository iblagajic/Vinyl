//
//  DisclosureButton.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 22/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DisclosureButton: UIControl {
    
    let titleLabel = UILabel.body
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let disclosureImageView = UIImageView(forAutoLayout: ())
        let bottomSeparator = UIView.separator
        
        [titleLabel, disclosureImageView, bottomSeparator].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 21),
            disclosureImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 44),
            disclosureImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            disclosureImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            bottomSeparator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 21),
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        disclosureImageView.image = .disclosure
        disclosureImageView.tintColor = .dark
    }
}

extension Reactive where Base: DisclosureButton {
    var tap: ControlEvent<Void> {
        return base.rx.controlEvent(.touchUpInside)
    }
}
