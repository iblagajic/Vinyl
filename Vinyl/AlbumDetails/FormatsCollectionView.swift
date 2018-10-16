//
//  FormatsCollectionView.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 01/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct FormatsSection {
    var title: String?
    var items: [String]
    
    init(items: [String], title: String? = nil) {
        self.title = title
        self.items = items
    }
}

extension FormatsSection: SectionModelType {
    typealias Item = String
    
    init(original: FormatsSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class FormatsCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        clipsToBounds = false
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 6
            layout.estimatedItemSize = CGSize(width: 94, height: 29)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
        } 
        showsHorizontalScrollIndicator = false
    }
}

extension Reactive where Base: FormatsCollectionView {
    
    func sections(_ sections: Observable<[FormatsSection]>) -> Disposable {
        let FormatCellReuseId = "FormatsCollectionCellId"
        base.register(FormatCell.self, forCellWithReuseIdentifier: FormatCellReuseId)
        let dataSource = RxCollectionViewSectionedReloadDataSource<FormatsSection>(configureCell: { (_, cv, ip, formatDescription) -> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: FormatCellReuseId, for: ip)
            if let FormatCell = cell as? FormatCell {
                FormatCell.titleLabel.text = formatDescription
            }
            return cell
        })
        return sections.bind(to: base.rx.items(dataSource: dataSource))
    }
}

