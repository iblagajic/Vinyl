//
//  Observable+Nil.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 22/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation
import RxSwift

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

extension ObservableType where E: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
     */
    
    public func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return Observable<E.Wrapped>.empty()
            }
            return Observable<E.Wrapped>.just(value)
        }
    }
}
