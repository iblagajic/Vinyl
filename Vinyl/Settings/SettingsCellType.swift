//
//  SettingsSection.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 07/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

enum SettingsCellType {
    case general
    case instructions
    case privacy
    
    case rate
    case share
    
    case credits
    case version
    
    var title: String {
        switch self {
        case .general:
            return .generalInformation
        case .instructions:
            return .instructionsTitle
        case .privacy:
            return .privacyPolicy
        case .rate:
            return .rate
        case .share:
            return .share
        case .credits:
            return .credits
        case .version:
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return .version + " " + version
            }
            return ""
        }
    }
}
