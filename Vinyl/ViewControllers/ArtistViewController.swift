//
//  ArtistViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 08/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StoreKit

class ArtistViewController: LoadingViewController {
    
    private let artistImageView = UIImageView(forAutoLayout: ())
    private let membersLabel = UILabel.body
    private let descriptionLabel = UILabel.body
    private var artistImageViewRatio: NSLayoutConstraint?
    
    init(artistResourceUrl: String) {
        super.init(nibName: nil, bundle: nil)
        
        let discogs = Discogs()
        
        let fetchRelease = discogs.fetchArtist(for: artistResourceUrl)
        
        handleObservable(observable: fetchRelease).subscribe(onNext: setup).disposed(by: bag)
    }

    
    private func setup(with artist: Artist) {
        title = artist.name
        let membersArray = artist.members?.filter { $0.active == true }.map { $0.name }
        if let members = membersArray {
            let membersString = String.members + " " + members.joined(separator: ", ")
            membersLabel.set(bodyText: membersString, boldPart: .members)
        }
        descriptionLabel.set(bodyText: artist.profilePlaintext)
        
        artistImageView.image = .placeholder
        artistImageView.contentMode = .scaleAspectFill
        let imageDriver: Driver<UIImage?>
        let primaryImage = artist.images.filter { $0.type == .primary }.first
        let anyImage = artist.images.first
        let image = primaryImage ?? anyImage
        if let imageUrlString = image?.resourceUrl,
            let imageUrl = URL(string: imageUrlString) {
            let request = URLRequest(url: imageUrl)
            imageDriver = URLSession.shared.rx.data(request: request).map(UIImage.init).asDriver(onErrorJustReturn: nil)
        } else {
            imageDriver = Driver.just(nil)
        }
        imageDriver.do(onNext: { [weak self] image in
            guard let imageView = self?.artistImageView,
                let image = image else {
                return
            }
            if let ratio = self?.artistImageViewRatio {
                imageView.removeConstraint(ratio)
            }
            self?.artistImageViewRatio = self?.artistImageView.constraintToKeepAspectRatio(of: image)
        }).drive(artistImageView.rx.image).disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContentView() -> UIView {
        let root = UIScrollView(frame: UIScreen.main.bounds)
        root.backgroundColor = .white
        let contentView  = UIView(forAutoLayout: ())
        root.addSubview(contentView)
        
        [artistImageView, membersLabel, descriptionLabel].forEach(contentView.addSubview)
        
        contentView.pinToSuperview()
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: root.widthAnchor),
            artistImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 44),
            artistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            artistImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            membersLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 22),
            membersLabel.leadingAnchor.constraint(equalTo: artistImageView.leadingAnchor),
            membersLabel.trailingAnchor.constraint(equalTo: artistImageView.trailingAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: membersLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: membersLabel.bottomAnchor, constant: 22),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44)
        ])
        
        membersLabel.textColor = .mediumGrey
        
        return root
    }
}

