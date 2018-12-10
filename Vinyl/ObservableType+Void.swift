//
//  ObservableType+Void.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 09/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    func mapVoid() -> Observable<Void> {
        return map { _ in () }
    }
}
