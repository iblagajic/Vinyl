//
//  Section.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 12/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import RxDataSources

struct Section<T> {
    var title: String?
    var items: [T]
    
    init(items: [T], title: String? = nil) {
        self.title = title
        self.items = items
    }
}

extension Section: SectionModelType {
    typealias Item = T
    
    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}
