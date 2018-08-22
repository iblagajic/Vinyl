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
    let titleLabel = UILabel.header
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
        header.widthAnchor.constraint(equalToConstant: root.frame.width).isActive = true
        
        [backButton, titleLabel, artistLabel, tracklistLabel, firstSeparator].forEach(header.addSubview)
        
        backButton.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor, constant: 33).isActive = true
        backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 44).isActive = true
        titleLabel.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 44).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -33).isActive = true
        artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        artistLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -33).isActive = true
        tracklistLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 44).isActive = true
        tracklistLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 44).isActive = true
        firstSeparator.topAnchor.constraint(equalTo: tracklistLabel.bottomAnchor, constant: 16).isActive = true
        firstSeparator.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 22).isActive = true
        firstSeparator.trailingAnchor.constraint(equalTo: header.trailingAnchor).isActive = true
        firstSeparator.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale).isActive = true
        firstSeparator.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        
        tracklistTableView.tableHeaderView = header
        tracklistTableView.separatorInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        tracklistTableView.separatorColor = UIColor.steelGrey.withAlphaComponent(0.3)
        tracklistTableView.rowHeight = 64
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
