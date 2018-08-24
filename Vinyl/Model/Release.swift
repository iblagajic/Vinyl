//
//  Release.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

struct Release: Codable {
    let title: String
    let artists_sort: String
    let lowest_price: Double?
    let notes: String?
    let images: [Image]
    let tracklist: [Track]
    let released_formatted: String
    let formats: [Format]
}
