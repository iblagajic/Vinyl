//
//  SearchCell.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 28/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchResultsUpdateable {
    func update(with searchResult: SearchResult)
}

class SearchCell: UICollectionViewCell, SearchResultsUpdateable {
    private let albumImageView = UIImageView(forAutoLayout: ())
    private let releaseTitleLabel = UILabel.body
    private let infoLabel = UILabel.metadata
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        [albumImageView, releaseTitleLabel, infoLabel].forEach(contentView.addSubview)
        albumImageView.pinToSuperview(anchors: [.left, .top, .bottom])
        albumImageView.widthAnchor.constraint(equalTo: albumImageView.heightAnchor).isActive = true
        releaseTitleLabel.pinToSuperview(anchors: [.top, .right], withInsets: UIEdgeInsets(top: .margin, left: 0, bottom: 0, right: -16))
        releaseTitleLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: .margin).isActive = true
        infoLabel.pinToSuperview(anchors: [.bottom, .right], withInsets: UIEdgeInsets(top: 0, left: 0, bottom: -6, right: -16))
        infoLabel.topAnchor.constraint(equalTo: releaseTitleLabel.bottomAnchor, constant: 5).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: releaseTitleLabel.leadingAnchor).isActive = true
        infoLabel.setContentHuggingPriority(.required, for: .vertical)
        let width = UIScreen.main.bounds.width - 2 * 2 * .margin
        contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        releaseTitleLabel.numberOfLines = 3
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 11
        contentView.clipsToBounds = true
        setShadow()
    }
    
    func update(with searchResult: SearchResult) {
        bag = DisposeBag()
        albumImageView.image = .placeholder
        let imageDriver: Driver<UIImage?>
        if let imageUrl = URL(string: searchResult.thumb) {
            let request = URLRequest(url: imageUrl)
            imageDriver = URLSession.shared.rx.data(request: request).map(UIImage.init).asDriver(onErrorJustReturn: nil)
        } else {
            imageDriver = Driver.just(nil)
        }
        imageDriver.filter { $0 != nil }.drive(albumImageView.rx.image).disposed(by: bag)
        releaseTitleLabel.set(bodyText: searchResult.title)
        var releaseDetailsString = searchResult.country
        if let year = searchResult.year {
            releaseDetailsString += ", " + year
        }
        infoLabel.text = releaseDetailsString
    }
    
    override func prepareForReuse() {
        releaseTitleLabel.text = nil
        infoLabel.text = nil
        albumImageView.image = .placeholder
    }
}
