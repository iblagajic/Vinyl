//
//  AlbumInfoCell.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 07/06/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

enum AlbumInfoCellType {
    case artist(ArtistLite)
    case tracks(count: Int, lenght: Int)
    case discogs(Double?)
    
    var subtitle: String? {
        switch self {
        case .artist:
            return .artist
        case .tracks(_, let lenght):
            let min = lenght/60
            let components = DateComponents(minute: min)
            return lenght > 0 ? DateComponentsFormatter.minutes.string(from: components) : .tracklist
        case .discogs:
            return .buyOn
        }
    }
    
    var title: String? {
        switch self {
        case .artist(let artist):
            return artist.name
        case .tracks(let tracksCount, _):
            return String(format: .tracksCount, tracksCount)
        case .discogs(let price):
            if let price = price, let priceFormatted = NumberFormatter.currency.string(from: NSNumber(value: price)) {
                return String(format: .buyFrom, priceFormatted)
            } else {
                return .notAvailable
            }
        }
    }
}

class AlbumInfoCell: UITableViewCell {
    private let subtitle = UILabel.metadata
    private let title = UILabel.headline
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func update(with model: AlbumInfoCellType) {
        subtitle.text = model.subtitle?.uppercased()
        title.text = model.title
    }
    
    private func setup() {
        accessoryType = .disclosureIndicator
        tintColor = .mediumGrey
        [subtitle, title].forEach(contentView.addSubview)
        subtitle.pinToSuperview(anchors: [.top, .left, .right], withInsets: UIEdgeInsets(top: 14, left: 22, bottom: 0, right: -52))
        title.pinToSuperview(anchors: [.left, .bottom, .right], withInsets: UIEdgeInsets(top: 0, left: 22, bottom: -11, right: -52))
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: subtitle.bottomAnchor),
        ])
        selectionStyle = .none
    }
}
