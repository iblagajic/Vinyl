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
    
    static var header3: UILabel {
        let label = UILabel(forAutoLayout: ())
        label.font = .header3
        label.textColor = .dark
        label.numberOfLines = 1
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
        label.font = .bodyBold
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
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: headerText,
                                                        attributes: [NSAttributedStringKey.paragraphStyle : paragraphStyle,
                                                                     NSAttributedStringKey.font : font,
                                                                     NSAttributedStringKey.foregroundColor : textColor])
        if let highlightPart = highlightPart {
            attributedTitle.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                           NSAttributedStringKey.foregroundColor : UIColor.melon,
                                           NSAttributedStringKey.font : UIFont.headerBold ?? UIFont()],
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
                                                        attributes: [NSAttributedStringKey.paragraphStyle : paragraphStyle,
                                                                     NSAttributedStringKey.font : font,
                                                                     NSAttributedStringKey.foregroundColor : textColor])
        
        if let boldText = boldPart {
            attributedTitle.addAttribute(NSAttributedStringKey.font, value: UIFont.bodyBold ?? UIFont(), range: (bodyText as NSString).range(of: boldText))
        }
        
        attributedText = attributedTitle
    }
}
