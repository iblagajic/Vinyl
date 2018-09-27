//
//  UILabel+Styled.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UILabel {
    
    static var block: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .block
        label.textColor = .dark
        return label
    }
    
    static var header: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .header
        label.textColor = .dark
        label.numberOfLines = 0
        return label
    }
    
    static var copyableHeader: CopyableLabel {
        let label = CopyableLabel(forAutoLayout: ())
        label.font = .header
        label.textColor = .dark
        label.numberOfLines = 0
        return label
    }
    
    static var headerLight: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .header
        label.textColor = .steelGrey
        label.numberOfLines = 0
        return label
    }
    
    static var header2: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .header2
        label.textColor = .dark
        label.numberOfLines = 0
        return label
    }
    
    static var subheader: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .subheader
        label.textColor = .dark
        label.numberOfLines = 0
        return label
    }
    
    static var subheaderDark: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .subheader
        label.textColor = .dark
        label.numberOfLines = 0
        return label
    }
    
    static var body: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .body
        label.textColor = .dark
        label.numberOfLines = 0
        return label
    }
    
    static var bodyLight: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .body
        label.textColor = .steelGrey
        return label
    }
    
    static var format: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .metadata
        label.textColor = .white
        return label
    }
    
    static var position: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .bodyBold
        label.textColor = .dark
        return label
    }
    
    func set(headerText: String, highlightPart: String? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: headerText,
                                                        attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                                                     NSAttributedString.Key.font : font,
                                                                     NSAttributedString.Key.foregroundColor : textColor])
        if let highlightPart = highlightPart {
            attributedTitle.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                           NSAttributedString.Key.foregroundColor : UIColor.melon,
                                           NSAttributedString.Key.font : UIFont.headerBold ?? UIFont()],
                                             range: (headerText as NSString).range(of: highlightPart))
        }
        attributedText = attributedTitle
    }
    
    func set(bodyText: String,
             boldPart: String? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: bodyText,
                                                        attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                                                     NSAttributedString.Key.font : font,
                                                                     NSAttributedString.Key.foregroundColor : textColor])
        
        if let boldText = boldPart {
            attributedTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.bodyBold ?? UIFont(), range: (bodyText as NSString).range(of: boldText))
        }
        
        attributedText = attributedTitle
    }
}

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
