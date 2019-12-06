//
//  Discogs.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation
import RxSwift

enum DiscogsError: Error {
    case invalidUrl
    case noResults
    case unavailable
}

class Discogs {
    
    private let base = "https://api.discogs.com"
    
    func search(query: String) -> Observable<[SearchResultsSection]> {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Observable.error(DiscogsError.invalidUrl)
        }
        let path = base + "/database/search?q=" + query + "&type=release&format=Vinyl"
        let searchResults: Observable<SearchResults> = request(path: path)
        return searchResults.map { searchResults -> [SearchResultsSection] in
            var sections = [SearchResultsSection]()
            if let first = searchResults.results.first {
                sections.append(SearchResultsSection(items: [first], title: .topResult))
            }
            let other = Array(searchResults.results.dropFirst())
            if !other.isEmpty {
                sections.append(SearchResultsSection(items: other, title: .otherResults))
            }
            return sections
        }
    }
    
    func fetchRelease(for path: String) -> Observable<Release> {
        return request(path: path)
    }
    
    func fetchArtist(for path: String) -> Observable<Artist> {
        return request(path: path)
    }
    
    private func request<T: Codable>(path: String) -> Observable<T> {
        guard let url = URL(string: path) else {
            return Observable.error(DiscogsError.invalidUrl)
        }
        var request = URLRequest(url: url)
        request.setValue("Discogs key=\(key), secret=\(secret)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.discogs.v2.plaintext+json", forHTTPHeaderField: "Accept")
        return URLSession.shared.rx.data(request: request).retry(3).flatMap { data -> Observable<T> in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let release = try decoder.decode(T.self, from: data)
                return Observable.just(release)
            } catch {
                return Observable.error(DiscogsError.noResults)
            }
            }.catchError { error in
                let error = error as NSError
                if error.code == -1009 {
                    return Observable.error(DiscogsError.unavailable)
                }
                return Observable.error(error)
        }
    }
}
