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

class AlbumViewController: UIViewController {
    
    let backButton = UIButton.back
    let artistLabel = UILabel.subheader
    let titleLabel = UILabel.copyableHeader
    let albumImageView = UIImageView(forAutoLayout: ())
    let vinylImageView = UIImageView(forAutoLayout: ())
    let dateLabel = UILabel.bodyLight
    let formatsCollectionView = FormatsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let priceLabel = UILabel.body
    let disclosureButton = DisclosureButton(forAutoLayout: ())
    let descriptionTitleLabel = UILabel.header2
    let descriptionLabel = UILabel.body
    
    private let bag = DisposeBag()
    
    init(release: Release) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = release.title
        artistLabel.text = release.artists_sort
        dateLabel.text = String(format: .releasedOn, release.released_formatted)
        if let price = release.lowest_price {
            let priceString = "$\(price) + shipping" // TODO: localize
            let sellsForString = String(format: .sellsFor, priceString)
            priceLabel.set(bodyText: sellsForString, boldPart: priceString)
            priceLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer()
            priceLabel.addGestureRecognizer(tapGesture)
            tapGesture.rx.event.subscribe(onNext: { _ in
                if let url = URL(string: "https://www.discogs.com/sell/release/\(release.id)") {
                    UIApplication.shared.open(url, options: [:])
                }
            }).disposed(by: bag)
        } else {
            priceLabel.text = .notAvailable
        }
        disclosureButton.titleLabel.text = .tracklist
        descriptionTitleLabel.text = .description
        if let notes = release.notes {
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
        if let imageUrlString = image?.resource_url,
            let imageUrl = URL(string: imageUrlString) {
            let request = URLRequest(url: imageUrl)
            imageDriver = URLSession.shared.rx.data(request: request).map(UIImage.init).asDriver(onErrorJustReturn: nil)
        } else {
            imageDriver = Driver.just(nil)
        }
        imageDriver.do(onNext: { [weak self] _ in
            self?.vinylImageView.isHidden = false
        }).filter { $0 != nil }.drive(albumImageView.rx.image).disposed(by: bag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }).disposed(by: bag)
        
        let formatDescriptions = release.formats.reduce([]) { (result, format) -> [String] in
            var array = result
            array.append(contentsOf: format.descriptions)
            return array
        }
        Observable.just([FormatsSection(items: formatDescriptions)]).bind(to: formatsCollectionView.rx.sections).disposed(by: bag)
        
        let tracklistViewController = TracklistViewController(release: release, image: imageDriver)
        disclosureButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.pushViewController(tracklistViewController, animated: true)
        }).disposed(by: bag)
        
        vinylImageView.transform = CGAffineTransform(translationX: -44, y: 0).rotated(by: -CGFloat.pi/4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.vinylImageView.transform = .identity
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
        
        [backButton, artistLabel, titleLabel, albumWithVinyl, dateLabel, formatsCollectionView, priceLabel, disclosureButton, descriptionTitleLabel, descriptionLabel].forEach(contentView.addSubview)
        
        contentView.pinToSuperview()
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: root.widthAnchor),
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 33),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            artistLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 33),
            artistLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            titleLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: artistLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: artistLabel.trailingAnchor),
            albumWithVinyl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44),
            albumWithVinyl.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            albumWithVinyl.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: albumWithVinyl.bottomAnchor, constant: 22),
            dateLabel.leadingAnchor.constraint(equalTo: albumWithVinyl.leadingAnchor),
            formatsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            formatsCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 33),
            formatsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            formatsCollectionView.heightAnchor.constraint(equalToConstant: 29),
            priceLabel.topAnchor.constraint(equalTo: formatsCollectionView.bottomAnchor, constant: 33),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            disclosureButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 22),
            disclosureButton.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
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
