//
//  UITextView+Styled.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 04/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UITextView {
    
    static var body: UITextView {
        let textView = UITextView(forAutoLayout: ())
        textView.font = .body
        textView.textColor = .dark
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }
    
    static var header: UITextView {
        let textView = UITextView(forAutoLayout: ())
        textView.font = .header
        textView.textColor = .dark
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }
    
    func set(headerText: String, highlightPart: String? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: headerText,
                                                        attributes: [NSAttributedStringKey.paragraphStyle : paragraphStyle,
                                                                     NSAttributedStringKey.font : font ?? UIFont(),
                                                                     NSAttributedStringKey.foregroundColor : textColor ?? UIColor()])
        if let highlightPart = highlightPart {
            attributedTitle.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                           NSAttributedStringKey.foregroundColor : UIColor.melon,
                                           NSAttributedStringKey.font : UIFont.headerBold ?? UIFont()],
                                          range: (headerText as NSString).range(of: highlightPart))
        }
        attributedText = attributedTitle
    }
    
    func set(bodyText: String,
             boldPart: String? = nil,
             underlineParts: [String] = [],
             highlightPart: String? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: bodyText,
                                                        attributes: [NSAttributedStringKey.paragraphStyle : paragraphStyle,
                                                                     NSAttributedStringKey.font : font ?? UIFont(),
                                                                     NSAttributedStringKey.foregroundColor : textColor ?? UIColor()])
        
        if let boldText = boldPart {
            attributedTitle.addAttribute(NSAttributedStringKey.font, value: UIFont.bodyBold ?? UIFont(), range: (bodyText as NSString).range(of: boldText))
        }
        underlineParts.forEach { underlineText in
            attributedTitle.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: (bodyText as NSString).range(of: underlineText))
        }
        if let highlightPart = highlightPart {
            attributedTitle.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                           NSAttributedStringKey.foregroundColor : UIColor.melon,
                                           NSAttributedStringKey.font : UIFont.bodyBold ?? UIFont()],
                                          range: (bodyText as NSString).range(of: highlightPart))
        }
        
        attributedText = attributedTitle
    }
    
}
