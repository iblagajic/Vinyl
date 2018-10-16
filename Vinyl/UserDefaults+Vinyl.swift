//
//  USerDefaults+Vinyl.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 11/10/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

fileprivate var albumViewCountId = "albumViewCount"

extension UserDefaults {
    
    static var shouldShowRateDialog: Bool {
        let currentCount = UserDefaults.standard.integer(forKey: albumViewCountId)
        let incrementedCount = currentCount+1
        UserDefaults.standard.set(incrementedCount, forKey: albumViewCountId)
        return [3, 8].contains(incrementedCount) || incrementedCount%20 == 0
    }
    
}
