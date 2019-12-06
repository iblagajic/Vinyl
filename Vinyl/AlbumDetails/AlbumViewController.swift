//
//  AlbumViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StoreKit

class AlbumViewController: LoadingViewController {
    
    private let albumImageView = UIImageView(forAutoLayout: ())
    private let vinylImageView = UIImageView(forAutoLayout: ())
    private let formatsCollectionView = FormatsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let infoTableView = DynamicTableView(forAutoLayout: ())
    private let detailsTitleLabel = UILabel.metadata
    private let detailsTextView = UITextView.body
    
    init(resourceUrl: String) {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.largeTitleDisplayMode = .always
        
        let discogs = Discogs()
        
        let fetchRelease = discogs.fetchRelease(for: resourceUrl)
        
        handleObservable(observable: fetchRelease).subscribe(onNext: { [weak self] release in
            self?.setup(with: release)
        }).disposed(by: bag)
    }

    init(code: String) {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.largeTitleDisplayMode = .always
        
        let discogs = Discogs()
        
        let fetchRelease = discogs.search(query: code)
            .flatMap { searchResults -> Observable<Release> in
                guard let firstUrl = searchResults.first?.items.first?.resourceUrl else {
                    return Observable.error(DiscogsError.noResults)
                }
                return discogs.fetchRelease(for: firstUrl)
        }
        
        handleObservable(observable: fetchRelease).subscribe(onNext: { [weak self] release in
            self?.setup(with: release)
        }).disposed(by: bag)
    }
    
    private func setup(with release: Release) {
        title = release.title

        vinylImageView.image = .realisticVinyl
        vinylImageView.isHidden = true
        
        albumImageView.image = .placeholder
        albumImageView.contentMode = .scaleAspectFill
        let imageDriver: Driver<UIImage?>
        let primaryImage = release.images.filter { $0.type == .primary }.first
        let anyImage = release.images.first
        let image = primaryImage ?? anyImage
        if let imageUrlString = image?.resourceUrl,
            let imageUrl = URL(string: imageUrlString) {
            let request = URLRequest(url: imageUrl)
            imageDriver = URLSession.shared.rx.data(request: request).map(UIImage.init).asDriver(onErrorJustReturn: nil)
        } else {
            imageDriver = Driver.just(nil)
        }
        imageDriver.do(onNext: { [weak self] _ in
            self?.vinylImageView.isHidden = false
        }).filter { $0 != nil }.drive(albumImageView.rx.image).disposed(by: bag)
        
        var formats = release.formats.reduce([]) { (result, format) -> [String] in
            var array = result
            array.append(contentsOf: format.descriptions)
            return array
        }.map { FormatCellType.format($0) }
        if let date = release.releasedFormatted {
            formats.insert(FormatCellType.date(date), at: 0)
        }
        Observable.just([FormatsSection(items: formats)]).bind(to: formatsCollectionView.rx.sections).disposed(by: bag)
        
//        vinylImageView.transform = CGAffineTransform(translationX: -44, y: 0).rotated(by: -CGFloat.pi/4)
        
        let infoCellReuseId = "InfoCellReuseId"
        infoTableView.register(AlbumInfoCell.self, forCellReuseIdentifier: infoCellReuseId)
        var cells = [AlbumInfoCellType.tracks(count: release.tracklist.count, lenght: release.duration)]
        if let artist = release.artists.first {
            cells.insert(AlbumInfoCellType.artist(artist), at: 0)
        }
        if let price = release.lowestPrice {
            cells.append(.discogs(price))
        }
        Observable.just(cells).bind(to: infoTableView.rx.items(cellIdentifier: infoCellReuseId)) { (_, albumInfoCellType, cell) in
            if let cell = cell as? AlbumInfoCell {
                cell.update(with: albumInfoCellType)
            }
        }.disposed(by: bag)
        
        infoTableView.rx.modelSelected(AlbumInfoCellType.self).subscribe(onNext: { [weak self] cell in
            switch cell {
            case .artist(let artist):
                self?.navigationController?.pushViewController(ArtistViewController(artistResourceUrl: artist.resourceUrl), animated: true)
            case .tracks:
                self?.navigationController?.pushViewController(TracklistViewController(release: release), animated: true)
            case .discogs:
                if let url = URL(string: "https://www.discogs.com/sell/release/\(release.id)") {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        }).disposed(by: bag)
        
        var releasedString = String()
        if let labelNames = release.labelNames {
            releasedString += " " + String(format: .byLabels, labelNames)
        }
        if let countryName = release.country {
            releasedString += " " + String(format: .inCountry, countryName)
        }
        if !releasedString.isEmpty {
            releasedString = .released + releasedString + ".\n"
        }
        if let detailsText = release.notesPlaintext {
            detailsTitleLabel.text = String.details.uppercased()
            detailsTextView.set(bodyText: releasedString + detailsText)
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.shouldShowRateDialog {
            SKStoreReviewController.requestReview()
        }
    }
    
    override func setupContentView() -> UIView {
        let root = UIScrollView(frame: UIScreen.main.bounds)
        root.backgroundColor = .white
        let contentView = UIView(forAutoLayout: ())
        root.addSubview(contentView)
        
        let albumWithVinyl = UIView(forAutoLayout: ())
        [vinylImageView, albumImageView].forEach(albumWithVinyl.addSubview)
        
        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: albumWithVinyl.leadingAnchor),
            albumImageView.topAnchor.constraint(equalTo: albumWithVinyl.topAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: albumWithVinyl.bottomAnchor),
            albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor),
            vinylImageView.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 43),
            vinylImageView.topAnchor.constraint(equalTo: albumImageView.topAnchor),
            vinylImageView.trailingAnchor.constraint(equalTo: albumWithVinyl.trailingAnchor),
            vinylImageView.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor),
            vinylImageView.widthAnchor.constraint(equalTo: vinylImageView.widthAnchor)
        ])
        
        [albumWithVinyl, formatsCollectionView, infoTableView, detailsTitleLabel, detailsTextView].forEach(contentView.addSubview)
        
        contentView.pinToSuperview()
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: root.widthAnchor),
            albumWithVinyl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 22),
            albumWithVinyl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            albumWithVinyl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            formatsCollectionView.topAnchor.constraint(equalTo: albumWithVinyl.bottomAnchor, constant: 22),
            formatsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            formatsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            formatsCollectionView.heightAnchor.constraint(equalToConstant: 30),
            infoTableView.topAnchor.constraint(equalTo: formatsCollectionView.bottomAnchor, constant: 11),
            infoTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailsTitleLabel.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 11),
            detailsTitleLabel.leadingAnchor.constraint(equalTo: albumWithVinyl.leadingAnchor),
            detailsTextView.leadingAnchor.constraint(equalTo: detailsTitleLabel.leadingAnchor),
            detailsTextView.topAnchor.constraint(equalTo: detailsTitleLabel.bottomAnchor, constant: 11),
            detailsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            detailsTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44)
        ])
        
        infoTableView.estimatedRowHeight = 66
        infoTableView.rowHeight = UITableView.automaticDimension
        infoTableView.separatorInset = .zero
        infoTableView.separatorColor = .pale
        infoTableView.isScrollEnabled = false
        
        return root
    }
}
