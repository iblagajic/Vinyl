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
    
    let backgroundImageView = UIImageView(forAutoLayout: ())
    let visualEffectView = UIVisualEffectView(forAutoLayout: ())
    let backButton = UIButton.back
    let titleLabel = UILabel.copyableHeader
    let artistLabel = UILabel.subheader
    let tracklistLabel = UILabel.header2
    let firstSeparator = UIView.separator
    let tracklistTableView = UITableView(forAutoLayout: ())
    private let bag = DisposeBag()
    
    init(release: Release, image: Driver<UIImage?>) {
        super.init(nibName: nil, bundle: nil)
        Observable.just(release.tracklist).bind(to: tracklistTableView.rx.items).disposed(by: bag)
        image.drive(backgroundImageView.rx.image).disposed(by: bag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
        
        titleLabel.text = release.title
        artistLabel.text = release.artists_sort
        tracklistLabel.text = .tracklist
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tracklistTableView.tableHeaderView?.layoutIfNeeded()
    }
    
    override func loadView() {
        let root = UIView.background
        
        [backgroundImageView, visualEffectView, tracklistTableView].forEach(root.addSubview)
        backgroundImageView.pinToSuperview()
        visualEffectView.pinToSuperview()
        tracklistTableView.pinToSuperview()
        
        let header = UIView(forAutoLayout: ())
        
        [backButton, titleLabel, artistLabel, tracklistLabel, firstSeparator].forEach(header.addSubview)
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalToConstant: root.frame.width),
            backButton.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor, constant: 33),
            backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 35),
            artistLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 33),
            artistLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 44),
            artistLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -22),
            titleLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: artistLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: artistLabel.trailingAnchor),
            tracklistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 33),
            tracklistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            firstSeparator.topAnchor.constraint(equalTo: tracklistLabel.bottomAnchor, constant: 14),
            firstSeparator.leadingAnchor.constraint(equalTo: tracklistLabel.leadingAnchor),
            firstSeparator.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            firstSeparator.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            firstSeparator.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
        
        tracklistTableView.tableHeaderView = header
        tracklistTableView.separatorInset = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 0)
        tracklistTableView.separatorColor = .veryLightPink
        tracklistTableView.rowHeight = 65
        tracklistTableView.backgroundColor = nil
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.alpha = 0.3
        visualEffectView.effect = UIBlurEffect(style: .extraLight)
        
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
