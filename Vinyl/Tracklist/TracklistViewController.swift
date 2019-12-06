//
//  TracklistViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 22/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TracklistViewController: UIViewController {
    
    let tracklistLabel = UILabel.headline
    let firstSeparator = UIView.separator
    let tracklistTableView = UITableView(frame: UIScreen.main.bounds)
    private let bag = DisposeBag()
    
    init(release: Release) {
        super.init(nibName: nil, bundle: nil)
        
        Observable.just(release.tracklist).bind(to: tracklistTableView.rx.items).disposed(by: bag)
        
        title = release.title
        tracklistLabel.text = .tracklist

        tracklistTableView.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tracklistTableView.tableHeaderView?.layoutIfNeeded()
    }
    
    override func loadView() {
        let root = tracklistTableView
        
        let header = UIView(forAutoLayout: ())
        
        [tracklistLabel, firstSeparator].forEach(header.addSubview)
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalToConstant: root.frame.width),
            header.heightAnchor.constraint(equalToConstant: 55),
            tracklistLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            tracklistLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 22),
            firstSeparator.topAnchor.constraint(equalTo: tracklistLabel.bottomAnchor, constant: 11),
            firstSeparator.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            firstSeparator.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            firstSeparator.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            firstSeparator.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
        
        tracklistTableView.tableHeaderView = header
        tracklistTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tracklistTableView.separatorColor = .veryLightPink
        tracklistTableView.rowHeight = 55
        tracklistTableView.backgroundColor = nil
        
        tracklistTableView.backgroundColor = .white
        
        self.view = root
    }
}

extension Reactive where Base: UITableView {
    
    func items(_ items: Observable<[Track]>) -> Disposable {
        let cellReuseId = "TrackCellId"
        base.register(TrackCell.self, forCellReuseIdentifier: cellReuseId)
        return items.bind(to: base.rx.items(cellIdentifier: cellReuseId)) { (_, track, cell) in
            if let cell = cell as? TrackCell {
                cell.positionLabel.text = track.position
                cell.titleLabel.text = track.title
                cell.durationLabel.text = track.duration
            }
        }
    }
}
