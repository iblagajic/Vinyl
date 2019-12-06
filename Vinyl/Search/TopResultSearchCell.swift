//
//  TopResultSearchCell.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 25/05/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopResultSearchCell: UICollectionViewCell, SearchResultsUpdateable {
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
        let bottomOverlayView = UIView(forAutoLayout: ())
        [releaseTitleLabel, infoLabel].forEach(bottomOverlayView.addSubview)
        [albumImageView, bottomOverlayView].forEach(contentView.addSubview)
        albumImageView.pinToSuperview(anchors: [.left, .top, .right])
        bottomOverlayView.pinToSuperview(anchors: [.left, .bottom, .right])
        releaseTitleLabel.pinToSuperview(anchors: [.top, .left, .right], withInsets: UIEdgeInsets(top: 16, left: 11, bottom: 0, right: -11))
        infoLabel.pinToSuperview(anchors: [.left, .bottom, .right], withInsets: UIEdgeInsets(top: 0, left: 11, bottom: -11, right: -11))
        albumImageView.widthAnchor.constraint(equalTo: albumImageView.heightAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: releaseTitleLabel.bottomAnchor, constant: 11).isActive = true
        bottomOverlayView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: -11).isActive = true
        bottomOverlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        let width = UIScreen.main.bounds.width - 2 * 2 * .margin
        contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        releaseTitleLabel.numberOfLines = 3
        infoLabel.numberOfLines = 2
        bottomOverlayView.backgroundColor = .white
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
        let countryName: String
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: searchResult.country) {
            countryName = name
        } else {
            countryName = searchResult.country
        }
        infoLabel.text = "By \(searchResult.label.first ?? "") in \(countryName), \(searchResult.year ?? "")."
    }
}
