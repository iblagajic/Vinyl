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
    let disclosureImageView = UIImageView(forAutoLayout: ())
    let separator = UIView.separator
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        [titleLabel, disclosureImageView, separator].forEach(addSubview)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        disclosureImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 44).isActive = true
        disclosureImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        disclosureImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22).isActive = true
        disclosureImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        disclosureImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        separator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        disclosureImageView.image = .disclosure
        disclosureImageView.tintColor = .dark
    }
}

extension Reactive where Base: DisclosureButton {
    var tap: ControlEvent<Void> {
        return base.rx.controlEvent(.touchUpInside)
    }
}
