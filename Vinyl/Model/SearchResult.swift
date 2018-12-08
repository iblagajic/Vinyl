//
//  SearchResult.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

struct SearchResults: Codable {
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let resourceUrl: String
    let format: [String]
    let title: String
    let thumb: String
    let country: String
    let year: String?
}
