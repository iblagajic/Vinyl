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

class AlbumViewController: UIViewController {
    
    private let closeButton = UIButton.close
    private let moreButton = UIButton.more
    private let artistLabel = UILabel.subheader
    private let titleLabel = UILabel.copyableHeader
    private let albumImageView = UIImageView(forAutoLayout: ())
    private let vinylImageView = UIImageView(forAutoLayout: ())
    private let dateLabel = UILabel.bodyLight
    private let formatsCollectionView = FormatsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let disclosureButton = DisclosureButton(forAutoLayout: ())
    private let descriptionTitleLabel = UILabel.header2
    private let descriptionLabel = UILabel.body
    
    private let bag = DisposeBag()
    
    init(release: Release) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = release.title
        artistLabel.text = release.artistsSort.uppercased()
        if let releasedFormatted = release.releasedFormatted {
            dateLabel.text = String(format: .releasedOn, releasedFormatted)
        }
        if let price = release.lowestPrice {
            let priceString = "$\(price) + shipping" // TODO: localize
            let sellsForString = String(format: .sellsFor, priceString)
            disclosureButton.titleLabel.set(bodyText: sellsForString, boldPart: priceString, oneLine: true)
        } else {
            disclosureButton.titleLabel.text = .notAvailable
        }
        descriptionTitleLabel.text = .description
        if let notes = release.notesPlaintext {
            descriptionLabel.set(bodyText: notes)
        }
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
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }).disposed(by: bag)
        
        moreButton.rx.tap
            .map { [ActionSheetOption.artistDetails, .tracklist] }
            .flatMap(presentCustomActionSheet)
            .subscribe(onNext: { [weak self] option in
                switch option {
                case .artistDetails:
                    let loadingViewController = LoadingViewController(artistResourceUrl: release.mainArtistResourceUrl)
                    self?.navigationController?.pushViewController(loadingViewController, animated: true)
                case.tracklist:
                    let tracklistViewController = TracklistViewController(release: release, image: imageDriver)
                    self?.navigationController?.pushViewController(tracklistViewController, animated: true)
                }
            })
            .disposed(by: bag)
        
        let formatDescriptions = release.formats.reduce([]) { (result, format) -> [String] in
            var array = result
            array.append(contentsOf: format.descriptions)
            return array
        }
        Observable.just([FormatsSection(items: formatDescriptions)]).bind(to: formatsCollectionView.rx.sections).disposed(by: bag)
        
        disclosureButton.rx.tap.subscribe(onNext: {
            if let url = URL(string: "https://www.discogs.com/sell/release/\(release.id)") {
                UIApplication.shared.open(url, options: [:])
            }
        }).disposed(by: bag)
        
        vinylImageView.transform = CGAffineTransform(translationX: -44, y: 0).rotated(by: -CGFloat.pi/4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.vinylImageView.transform = .identity
        }) { completed in
            if completed && UserDefaults.shouldShowRateDialog {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    override func loadView() {
        let root = UIScrollView(frame: UIScreen.main.bounds)
        root.backgroundColor = .white
        let contentView  = UIView(forAutoLayout: ())
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
        
        [closeButton, moreButton, artistLabel, titleLabel, albumWithVinyl, dateLabel, formatsCollectionView, disclosureButton, descriptionTitleLabel, descriptionLabel].forEach(contentView.addSubview)
        
        contentView.pinToSuperview()
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: root.widthAnchor),
            closeButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 33),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            moreButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            artistLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 33),
            artistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            titleLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: artistLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: artistLabel.trailingAnchor),
            albumWithVinyl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44),
            albumWithVinyl.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            albumWithVinyl.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: albumWithVinyl.bottomAnchor, constant: 33),
            dateLabel.leadingAnchor.constraint(equalTo: albumWithVinyl.leadingAnchor),
            formatsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            formatsCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 33),
            formatsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            formatsCollectionView.heightAnchor.constraint(equalToConstant: 29),
            disclosureButton.topAnchor.constraint(equalTo: formatsCollectionView.bottomAnchor, constant: 11),
            disclosureButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            disclosureButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: disclosureButton.leadingAnchor),
            descriptionTitleLabel.topAnchor.constraint(equalTo: disclosureButton.bottomAnchor, constant: 33),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 22),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44)
        ])
        
        self.view = root
    }
}
