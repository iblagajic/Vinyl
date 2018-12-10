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
    let profile: String
    let members: [ArtistLite]
    let images: [Image]
    
    var type: String {
        return members.count == 1 ? .artist : .band
    }
}
