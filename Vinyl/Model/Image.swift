//
//  Image.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 22/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

enum ImageType: String, Codable {
    case primary = "primary"
    case secondary = "secondary"
}

struct Image: Codable {
    let resourceUrl: String
    let type: ImageType
}
