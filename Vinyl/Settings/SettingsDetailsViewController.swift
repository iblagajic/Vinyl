//
//  SettingsDetailsViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 09/07/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class SettingsDetailsViewController: UIViewController {
    let textView = UITextView.body
    
    init(settingsCellType: SettingsCellType) {
        super.init(nibName: nil, bundle: nil)
        title = settingsCellType.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = textView
    }
}
