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
    
    var mainArtistResourceUrl: String {
        return artists.first.map { $0.resourceUrl } ?? ""
    }
}
