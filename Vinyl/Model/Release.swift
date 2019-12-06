//
//  Release.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation

struct Release: Codable {
    let id: Int
    let title: String
    let artistsSort: String
    let lowestPrice: Double?
    let notesPlaintext: String?
    let images: [Image]
    let tracklist: [Track]
    let releasedFormatted: String?
    let formats: [Format]
    let artists: [ArtistLite]
    let labels: [Label]?
    let country: String?
    
    var mainArtistResourceUrl: String {
        return artists.first.map { $0.resourceUrl } ?? ""
    }
    
    var duration: Int {
        return tracklist.compactMap { $0.durationInSeconds }.reduce(0) { $0 + $1 }
    }
    
    var labelNames: String? {
        return labels?.map { $0.name }.joined(separator: ", ")
    }
}
