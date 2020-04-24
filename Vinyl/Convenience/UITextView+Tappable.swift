//
//  UILabel+Tappable.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 05/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextView {
    
    func didTap(oneOf texts: [String]) -> Observable<String> {
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        return tap.rx.event.map { $0.didTap(oneOf: texts) }.filterNil()
    }
}
