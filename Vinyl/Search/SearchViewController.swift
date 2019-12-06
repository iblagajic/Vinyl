//
//  SearchViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 28/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias SearchResultsSection = Section<SearchResult>

class SearchViewController: UICollectionViewController {
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = .search

        collectionView.backgroundColor = .white
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
    
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .dark
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        let discogs = Discogs()
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
            .filter { !$0.isEmpty }
            .flatMapLatest { query -> Driver<[SearchResultsSection]> in
                return discogs.search(query: query)
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
            }.drive(rx.sections)
            .disposed(by: bag)
        
        navigationItem.backBarButtonItem = .empty
        
        collectionView.rx.modelSelected(SearchResult.self).subscribe(onNext: { [weak self] searchResult in
            let albumViewController = AlbumViewController(resourceUrl: searchResult.resourceUrl)
            self?.navigationController?.pushViewController(albumViewController, animated: true)
        }).disposed(by: bag)
        
        collectionView.rx.willBeginDragging.subscribe(onNext: {
            searchController.resignFirstResponder()
        }).disposed(by: bag)
    }
}

extension Reactive where Base: SearchViewController {
    
    func sections(_ sections: Observable<[SearchResultsSection]>) -> Disposable {
        let searchCellReuseId = "SearchCollectionCellId"
        base.collectionView.register(SearchCell.self, forCellWithReuseIdentifier: searchCellReuseId)
        let topSearchCellReuseId = "TopSearchCollectionCellId"
        base.collectionView.register(TopResultSearchCell.self, forCellWithReuseIdentifier: topSearchCellReuseId)
        let searchHeaderReuseId = "SearchCollectionHeaderId"
        base.collectionView.register(UISearchCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: searchHeaderReuseId)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SearchResultsSection>(configureCell: { (_, cv, ip, searchResult) -> UICollectionViewCell in
            let identifier = ip.section == 0 ? topSearchCellReuseId : searchCellReuseId
            let cell = cv.dequeueReusableCell(withReuseIdentifier: identifier, for: ip)
            if let searchCell = cell as? SearchResultsUpdateable {
                searchCell.update(with: searchResult)
            }
            return cell
        }, configureSupplementaryView: { (ds, cv, kind, ip) -> UICollectionReusableView in
            let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: searchHeaderReuseId, for: ip)
            if let searchHeader = header as? UISearchCollectionViewHeader,
                let title = ds.sectionModels[ip.section].title {
                searchHeader.update(with: title)
            }
            return header
        })
        return sections.bind(to: base.collectionView.rx.items(dataSource: dataSource))
    }
}
