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
    
    func search(query: String) -> Observable<[SearchResult]> {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Observable.error(DiscogsError.invalidUrl)
        }
        let urlString = base + "/database/search?q=" + query + "&type=release&format=Vinyl"
        guard let url = URL(string: urlString) else {
            return Observable.error(DiscogsError.invalidUrl)
        }
        var request = URLRequest(url: url)
        request.setValue("Discogs key=\(key), secret=\(secret)", forHTTPHeaderField: "Authorization")
        return URLSession.shared.rx.data(request: request).flatMap { data -> Observable<[SearchResult]> in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let search = try decoder.decode(SearchResults.self, from: data)
                return Observable.just(search.results)
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
    
    func fetchRelease(for urlString: String) -> Observable<Release> {
        guard let url = URL(string: urlString) else {
            return Observable.error(DiscogsError.invalidUrl)
        }
        var request = URLRequest(url: url)
        request.setValue("Discogs key=\(key), secret=\(secret)", forHTTPHeaderField: "Authorization")
        return URLSession.shared.rx.data(request: request).retry(3).flatMap { data -> Observable<Release> in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let release = try decoder.decode(Release.self, from: data)
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
