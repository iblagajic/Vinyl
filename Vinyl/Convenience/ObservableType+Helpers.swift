//
//  ObservableType+Helpers.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 04/02/2020.
//  Copyright © 2020 Five Dollar Milkshake Limited. All rights reserved.
//

import RxSwift

extension ObservableType {

    var void: Observable<Void> {
        self.map { _ in }
    }
    
}

extension PrimitiveSequenceType where Trait == SingleTrait {

    var void: Single<Void> {
        self.map { _ in }
    }
    
}
