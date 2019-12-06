//
//  Track.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 22/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

struct Track: Codable {
    let duration: String
    let position: String
    let title: String
    
    var durationInSeconds: Int {
        var components = duration.components(separatedBy: ":")
        var totalSeconds = 0
        if let secondsString = components.popLast(),
            let seconds = Int(secondsString) {
            totalSeconds += seconds
        }
        if let minutesString = components.popLast(),
            let minutes = Int(minutesString) {
            totalSeconds += minutes*60
        }
        return totalSeconds
    }
}
