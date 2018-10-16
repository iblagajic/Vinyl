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
    
    let titleLabel = UILabel.header2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let topSeparator = UIView.separator
        let disclosureImageView = UIImageView(forAutoLayout: ())
        let bottomSeparator = UIView.separator
        
        [topSeparator, titleLabel, disclosureImageView, bottomSeparator].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            topSeparator.topAnchor.constraint(equalTo: topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topSeparator.bottomAnchor, constant: 16),
            disclosureImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 44),
            disclosureImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            disclosureImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            disclosureImageView.widthAnchor.constraint(equalToConstant: 9),
            disclosureImageView.heightAnchor.constraint(equalToConstant: 15),
            bottomSeparator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
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
