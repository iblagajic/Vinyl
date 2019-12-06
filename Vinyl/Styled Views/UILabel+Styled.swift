//
//  UILabel+Styled.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UILabel {
    
    static var bodyLight: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .body
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
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
    
    static var format: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .metadata
        label.textColor = .white
        return label
    }
    
    static var position: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .headline
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
                                                                     NSAttributedString.Key.font : font as Any,
                                                                     NSAttributedString.Key.foregroundColor : textColor as Any])
        if let highlightPart = highlightPart {
            attributedTitle.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                           NSAttributedString.Key.foregroundColor : UIColor.melon,
                                           NSAttributedString.Key.font : UIFont.headerBold ?? UIFont()],
                                             range: (headerText as NSString).range(of: highlightPart))
        }
        attributedText = attributedTitle
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
                                                                     NSAttributedString.Key.font : font as Any,
                                                                     NSAttributedString.Key.foregroundColor : textColor as Any])
        
        if let boldText = boldPart {
            attributedTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.bodyBold ?? UIFont(), range: (bodyText as NSString).range(of: boldText))
        }
        
        attributedText = attributedTitle
    }
}
