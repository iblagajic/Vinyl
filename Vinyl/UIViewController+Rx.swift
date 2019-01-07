//
//  UIViewController+Rx.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 09/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    
    public var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).mapVoid()
        return ControlEvent(events: source)
    }
    
    public var viewDidAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidAppear)).mapVoid()
        return ControlEvent(events: source)
    }
    
}
