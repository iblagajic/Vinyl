//
//  UISearchCollectionViewHeader.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 12/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class UISearchCollectionViewHeader: UICollectionReusableView {
    private let label = UILabel.metadata
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(label)
        label.pinToSuperview(withInsets: UIEdgeInsets(top: 3 * .margin, left: 2 * .margin, bottom: -.margin, right: -2 * .margin))
    }
    
    func update(with title: String) {
        label.text = title.uppercased()
    }
}
