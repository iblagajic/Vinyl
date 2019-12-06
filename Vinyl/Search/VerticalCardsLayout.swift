//
//  VerticalCardsLayout.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 12/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class VerticalCardsLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let width = UIScreen.main.bounds.width - 2 * 2 * .margin
        estimatedItemSize = CGSize(width: width, height: 110)
        minimumLineSpacing = 2 * .margin
        sectionInset = UIEdgeInsets(top: .margin, left: 2 * .margin, bottom: 2 * .margin, right: 2 * .margin)
        headerReferenceSize = CGSize(width: 0, height: 60)
    }
}

class SettingsCardsLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let width = UIScreen.main.bounds.width - 2 * .margin
        estimatedItemSize = CGSize(width: width, height: 147)
        minimumLineSpacing = 2 * .margin
        sectionInset = UIEdgeInsets(top: 2 * .margin, left: .margin, bottom: 2 * .margin, right: .margin)
    }
}

extension UICollectionViewLayout {
    var settingsCardsLayout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 2 * .margin
        layout.estimatedItemSize = CGSize(width: width, height: 147)
        layout.minimumLineSpacing = 2 * .margin
        layout.sectionInset = UIEdgeInsets(top: 2 * .margin, left: .margin, bottom: 2 * .margin, right: .margin)
        return layout
    }
}
