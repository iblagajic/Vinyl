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

class SearchCell: UITableViewCell {
    private let albumImageView = UIImageView(forAutoLayout: ())
    private let titleLabel = UILabel.subheader
    private let releaseDetailsLabel = UILabel.body
    private let formatsLabel = UILabel.bodyLight
    private var bag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
        titleLabel.text = searchResult.title
        var releaseDetailsString = searchResult.country
        if let year = searchResult.year {
             releaseDetailsString += ", " + year
        }
        releaseDetailsLabel.text = releaseDetailsString
        formatsLabel.text = searchResult.format.joined(separator: ", ")
    }
    
    private func setup() {
        [albumImageView, titleLabel, releaseDetailsLabel, formatsLabel].forEach(addSubview)
        albumImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        albumImageView.topAnchor.constraint(equalTo: topAnchor, constant: 33).isActive = true
        albumImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: albumImageView.topAnchor, constant: 11).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 22).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22).isActive = true
        releaseDetailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11).isActive = true
        releaseDetailsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        releaseDetailsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        formatsLabel.topAnchor.constraint(equalTo: releaseDetailsLabel.bottomAnchor, constant: 11).isActive = true
        formatsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        formatsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        titleLabel.numberOfLines = 2
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        albumImageView.image = .placeholder
    }
}
