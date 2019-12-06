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
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.dataDetectorTypes = [.link]
        textView.linkTextAttributes = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                       NSAttributedString.Key.underlineColor : textView.textColor ?? .dark]
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
                                                        attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                                                     NSAttributedString.Key.font : .header ?? UIFont(),
                                                                     NSAttributedString.Key.foregroundColor : UIColor.dark])
        if let highlightPart = highlightPart {
            attributedTitle.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                           NSAttributedString.Key.foregroundColor : UIColor.melon,
                                           NSAttributedString.Key.font : .headerBold ?? UIFont()],
                                          range: (headerText as NSString).range(of: highlightPart))
        }
        attributedText = attributedTitle
    }
    
    func set(bodyText: String,
             boldPart: String? = nil,
             underlineParts: [String] = [],
             highlightPart: String? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.paragraphSpacing = 12
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: bodyText,
                                                        attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                                                     NSAttributedString.Key.font : font ?? UIFont(),
                                                                     NSAttributedString.Key.foregroundColor : textColor ?? UIColor()])
        
        if let boldText = boldPart {
            attributedTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.bodyBold ?? UIFont(), range: (bodyText as NSString).range(of: boldText))
        }
        underlineParts.forEach { underlineText in
            attributedTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (bodyText as NSString).range(of: underlineText))
        }
        if let highlightPart = highlightPart {
            attributedTitle.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                           NSAttributedString.Key.foregroundColor : UIColor.melon,
                                           NSAttributedString.Key.font : UIFont.bodyBold ?? UIFont()],
                                          range: (bodyText as NSString).range(of: highlightPart))
        }
        
        attributedText = attributedTitle
    }
    
}
