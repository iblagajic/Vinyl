//
//  BodyWIthTitle.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 03/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class BodyWithTitle: UIView {
    
    let titleLabel = UILabel.header2
    let bodyLabel = UITextView.body
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        [titleLabel, bodyLabel].forEach(addSubview)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
