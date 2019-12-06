//
//  FloatingTabBar.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 30/09/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FloatingTabBar: UIView {

    let buttons: [UIButton]
    var dotCenter: NSLayoutConstraint?

    init(with items: [UITabBarItem]) {
        self.buttons = items.map { item -> UIButton in
            let button = UIButton(forAutoLayout: ())
            button.setImage(item.image, for: .normal)
            button.imageView?.tintColor = .mediumGrey
            button.tag = item.tag
            return button
        }
        super.init(frame: CGRect(x: 0, y: 0, width: 154, height: 55))
        let stackView = UIStackView(forAutoLayout: ())
        addSubview(stackView)
        stackView.pinToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        let leadingSpacer = UIView(forAutoLayout: ())
        stackView.addArrangedSubview(leadingSpacer)
        leadingSpacer.widthAnchor.constraint(equalToConstant: 11).isActive = true
        buttons.forEach { button in
            stackView.addArrangedSubview(button)
            button.widthAnchor.constraint(equalToConstant: 44).isActive = true
            button.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        }
        let trailingSpacer = UIView(forAutoLayout: ())
        stackView.addArrangedSubview(trailingSpacer)
        trailingSpacer.widthAnchor.constraint(equalToConstant: 11).isActive = true
        let dot = UIView(forAutoLayout: ())
        dot.layer.cornerRadius = 1.5
        dot.backgroundColor = .dark
        addSubview(dot)
        let dotCenter = dot.centerXAnchor.constraint(equalTo: leadingAnchor)
        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: 3),
            dot.heightAnchor.constraint(equalTo: dot.widthAnchor),
            dot.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            dotCenter
        ])
        self.dotCenter = dotCenter
        heightAnchor.constraint(equalToConstant: 55).isActive = true

        layer.cornerRadius = 27.5
        backgroundColor = .white
        setShadow()
        select(index: 1, animated: false)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(index: Int, animated: Bool) {
        buttons.forEach { button in
            if button.tag == index {
                button.imageView?.tintColor = .dark
                dotCenter?.constant = CGFloat((button.tag + 1) * 44) - 11
            } else {
                button.imageView?.tintColor = .mediumGrey
            }
        }
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.layoutIfNeeded()
        }
    }

}

extension Reactive where Base: FloatingTabBar {

    var tapped: Observable<Int> {
        return Observable.merge(base.buttons.map { button in button.rx.tap.map { button.tag } })
            .do(onNext: { [base] selectedTag in
                base.select(index: selectedTag, animated: false)
            })
    }
}
