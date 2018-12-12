//
//  ArtistLite.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 08/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

struct ArtistLite: Codable {
    let resourceUrl: String
    let name: String
    let active: Bool?
}
