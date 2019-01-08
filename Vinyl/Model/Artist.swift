//
//  Artist.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 08/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

struct Artist: Codable {
    let name: String
    let profilePlaintext: String
    let members: [ArtistLite]?
    let images: [Image]
    
    var type: String {
        guard let members = members else {
            return .artist
        }
        return members.count > 1 ? .band : .artist
    }
}
