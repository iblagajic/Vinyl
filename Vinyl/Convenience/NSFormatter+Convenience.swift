//
//  NSFormatter+Convenience.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 25/06/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    
    static var minutes: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.unitsStyle = .short
        return formatter
    }()
}

extension NumberFormatter {
    
    static var currency: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
}
