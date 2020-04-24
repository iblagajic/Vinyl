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
    
    func set(bodyText: String,
             boldPart: String? = nil,
             underlineParts: [String] = []) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.paragraphSpacing = 12
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: bodyText,
                                                        attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                                                     NSAttributedString.Key.font : UIFont.body,
                                                                     NSAttributedString.Key.foregroundColor : textColor ?? UIColor()])
        
        if let boldText = boldPart {
            attributedTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.bodyBold, range: (bodyText as NSString).range(of: boldText))
        }
        underlineParts.forEach { underlineText in
            attributedTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (bodyText as NSString).range(of: underlineText))
        }
        attributedText = attributedTitle
    }
    
}
