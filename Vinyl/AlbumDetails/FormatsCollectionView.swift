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

typealias FormatsSection = Section<FormatCellType>

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
            layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        } 
        showsHorizontalScrollIndicator = false
    }
}

extension Reactive where Base: FormatsCollectionView {
    
    func sections(_ sections: Observable<[FormatsSection]>) -> Disposable {
        let FormatCellReuseId = "FormatsCollectionCellId"
        base.register(FormatCell.self, forCellWithReuseIdentifier: FormatCellReuseId)
        let dataSource = RxCollectionViewSectionedReloadDataSource<FormatsSection>(configureCell: { (_, cv, ip, formatType) -> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: FormatCellReuseId, for: ip)
            if let formatCell = cell as? FormatCell {
                formatCell.update(with: formatType)
            }
            return cell
        })
        return sections.bind(to: base.rx.items(dataSource: dataSource))
    }
}

