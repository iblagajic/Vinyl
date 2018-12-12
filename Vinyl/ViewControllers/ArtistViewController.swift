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

class ArtistViewController: UIViewController {
    
    private let backButton = UIButton.back
    private let artistTypeLabel = UILabel.subheader
    private let artistNameLabel = UILabel.copyableHeader
    private let artistImageView = UIImageView(forAutoLayout: ())
    private let membersLabel = UILabel.bodyLight
    private let descriptionLabel = UILabel.body
    private var artistImageViewRatio: NSLayoutConstraint?
    
    private let bag = DisposeBag()
    
    init(artist: Artist) {
        super.init(nibName: nil, bundle: nil)
        artistTypeLabel.text = artist.type.uppercased()
        artistNameLabel.text = artist.name
        let members = artist.members.filter { $0.active == true}.map { $0.name }
        let membersString = String.members + " " + members.joined(separator: ", ")
        membersLabel.set(bodyText: membersString, boldPart: .members)
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
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let root = UIScrollView(frame: UIScreen.main.bounds)
        root.backgroundColor = .white
        let contentView  = UIView(forAutoLayout: ())
        root.addSubview(contentView)
        
        [backButton, artistTypeLabel, artistNameLabel, artistImageView, membersLabel, descriptionLabel].forEach(contentView.addSubview)
        
        contentView.pinToSuperview()
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: root.widthAnchor),
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 33),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            artistTypeLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 33),
            artistTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            artistTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            artistNameLabel.topAnchor.constraint(equalTo: artistTypeLabel.bottomAnchor, constant: 6),
            artistNameLabel.leadingAnchor.constraint(equalTo: artistTypeLabel.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: artistTypeLabel.trailingAnchor),
            artistImageView.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 44),
            artistImageView.leadingAnchor.constraint(equalTo: artistNameLabel.leadingAnchor),
            artistImageView.trailingAnchor.constraint(equalTo: artistNameLabel.trailingAnchor, constant: -22),
            membersLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 22),
            membersLabel.leadingAnchor.constraint(equalTo: artistImageView.leadingAnchor),
            membersLabel.trailingAnchor.constraint(equalTo: artistImageView.trailingAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: membersLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: membersLabel.bottomAnchor, constant: 22),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44)
        ])
        
        self.view = root
        
        membersLabel.numberOfLines = 0
    }
}

