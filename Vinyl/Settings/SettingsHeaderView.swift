//
//  SettingsHeaderView.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 29/06/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class SettingsHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        textLabel?.font = .metadata
        textLabel?.textColor = .mediumGrey
    }
}
