//
//  ActionSheetOption.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 08/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

enum ActionSheetOption {
    case artistDetails
    case tracklist
    
    var title: String {
        switch self {
        case .artistDetails:
            return .artistDetails
        case .tracklist:
            return .tracklist
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .artistDetails:
            return .artist
        case .tracklist:
            return .list
        }
    }
}
