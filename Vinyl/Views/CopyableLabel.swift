//
//  CopyableLabel.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 08/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import RxSwift

class CopyableLabel: UILabel {
    
    let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer()
        addGestureRecognizer(longPress)
        longPress.rx.event.subscribe(onNext: { [weak self] _ in
            self?.becomeFirstResponder()
            let menu = UIMenuController()
            menu.arrowDirection = .default
            if let superview = self?.superview,
                let frame = self?.frame,
                let `self` = self {
                menu.setTargetRect(frame, in: superview)
                menu.menuItems = [UIMenuItem(title: .copy, action: #selector(self.copyToPasteboard))]
            }
            menu.setMenuVisible(true, animated: true)
        }).disposed(by: bag)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc private func copyToPasteboard() {
        UIPasteboard.general.string = text
    }
    
}
