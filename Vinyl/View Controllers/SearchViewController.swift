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

class SearchViewController: UITableViewController {
    
    private let backButton = UIButton.back
    private let albumInputField = UITextField.standard
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let header = UIView(forAutoLayout: ())
        header.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        [backButton, albumInputField].forEach(header.addSubview)
        backButton.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor, constant: 33).isActive = true
        backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 33).isActive = true
        backButton.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        albumInputField.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 33).isActive = true
        albumInputField.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor, constant: 33).isActive = true
        albumInputField.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -44).isActive = true
        albumInputField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        tableView.separatorColor = .steelGrey
        tableView.rowHeight = 176
        tableView.delegate = nil
        tableView.dataSource = nil
        
        albumInputField.placeholder = .searchPlaceholder
        
        let searchResultCellId = "SearchResultCellId"
        tableView.register(SearchCell.self, forCellReuseIdentifier: searchResultCellId)
        
        let discogs = Discogs()
        
        albumInputField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(albumInputField.rx.text.orEmpty)
            .asDriver(onErrorJustReturn: "")
            .distinctUntilChanged()
            .flatMapLatest { query -> Driver<[SearchResult]> in
                if query.isEmpty {
                    return Driver.just([])
                } else {
                    return discogs.search(query: query)
                        .startWith([])
                        .asDriver(onErrorJustReturn: [])
                }
            }.drive(tableView.rx.items(cellIdentifier: searchResultCellId, cellType: SearchCell.self)) { (_, result, cell) in
                cell.update(with: result)
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(SearchResult.self).subscribe(onNext: { [weak self] searchResult in
            let loadingViewController = LoadingViewController(resourceUrl: searchResult.resource_url)
            let navigationController = UINavigationController(rootViewController: loadingViewController)
            navigationController.isNavigationBarHidden = true
            self?.present(navigationController, animated: true)
        }).disposed(by: bag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.albumInputField.resignFirstResponder()
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
        
        tableView.rx.didScroll.skip(1).subscribe(onNext: { [weak self] in
            self?.albumInputField.resignFirstResponder()
        }).disposed(by: bag)
        
        albumInputField.becomeFirstResponder()
    }
}
