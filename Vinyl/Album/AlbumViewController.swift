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
    
    let titleLabel = UILabel.header
    let artistLabel = UILabel.subheader
    let dateLabel = UILabel.bodyLight
    let closeButton = UIButton.close
    let albumImageView = UIImageView(forAutoLayout: ())
    let vinylImageView = UIImageView(forAutoLayout: ())
    let priceLabel = UILabel.body
    let formatsCollectionView = FormatsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let disclosureButton = DisclosureButton(forAutoLayout: ())
    let descriptionTitleLabel = UILabel.header2
    let descriptionLabel = UILabel.body
    
    private let bag = DisposeBag()
    
    init(release: Release) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = release.title
        artistLabel.text = release.artists_sort
        dateLabel.text = release.released_formatted
        if let price = release.lowest_price {
            let priceString = "$\(price) + shipping" // TODO: localize
            let sellsForString = String(format: .sellsFor, priceString)
            priceLabel.set(bodyText: sellsForString, boldPart: priceString)
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
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
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
        albumImageView.leadingAnchor.constraint(equalTo: albumWithVinyl.leadingAnchor).isActive = true
        albumImageView.topAnchor.constraint(equalTo: albumWithVinyl.topAnchor).isActive = true
        albumImageView.bottomAnchor.constraint(equalTo: albumWithVinyl.bottomAnchor).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: 211).isActive = true
        albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor).isActive = true
        vinylImageView.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 43).isActive = true
        vinylImageView.topAnchor.constraint(equalTo: albumImageView.topAnchor).isActive = true
        vinylImageView.trailingAnchor.constraint(equalTo: albumWithVinyl.trailingAnchor).isActive = true
        vinylImageView.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor).isActive = true
        vinylImageView.widthAnchor.constraint(equalTo: vinylImageView.heightAnchor).isActive = true
        
        [titleLabel, artistLabel, dateLabel, closeButton, albumWithVinyl, priceLabel, formatsCollectionView, disclosureButton, descriptionTitleLabel, descriptionLabel].forEach(contentView.addSubview)
        
        contentView.pinToSuperview()
        contentView.widthAnchor.constraint(equalTo: root.widthAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44).isActive = true
        artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: artistLabel.leadingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 11).isActive = true
        closeButton.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 22).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33).isActive = true
        albumWithVinyl.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 44).isActive = true
        albumWithVinyl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: albumWithVinyl.bottomAnchor, constant: 44).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        formatsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        formatsCollectionView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 22).isActive = true
        formatsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        formatsCollectionView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        disclosureButton.topAnchor.constraint(equalTo: formatsCollectionView.bottomAnchor, constant: 22).isActive = true
        disclosureButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22).isActive = true
        disclosureButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        descriptionTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionTitleLabel.topAnchor.constraint(equalTo: disclosureButton.bottomAnchor, constant: 33).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 22).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44).isActive = true
        
        self.view = root
        
        albumWithVinyl.layer.shadowColor = .dark
        albumWithVinyl.layer.shadowOffset = CGSize(width: 0, height: 3)
        albumWithVinyl.layer.shadowRadius = 11
        albumWithVinyl.layer.shadowOpacity = 0.3
    }
}
