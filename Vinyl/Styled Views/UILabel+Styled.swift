//
//  UILabel+Styled.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UILabel {
    
    static var body: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .body
        label.textColor = .dark
        label.numberOfLines = 0
        return label
    }

    static var headline: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .headline
        label.textColor = .dark
        label.numberOfLines = 0
        return label
    }

    static var headlineLightCentered: UILabel {
        let label = UILabel.headline
        label.textColor = .white
        label.textAlignment = .center
        return label
    }

    static var metadata: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .metadata
        label.textColor = .mediumGrey
        return label
    }

    static var format: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .metadata
        label.textColor = .white
        return label
    }
    
    func set(bodyText: String,
             boldPart: String? = nil,
             oneLine: Bool = false) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = oneLine ? 0 : 4
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: bodyText,
                                                        attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                                                     NSAttributedString.Key.font : UIFont.body,
                                                                     NSAttributedString.Key.foregroundColor : textColor ?? UIColor()])

        if let boldText = boldPart {
            attributedTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.bodyBold, range: (bodyText as NSString).range(of: boldText))
        }

        attributedText = attributedTitle
    }
}
