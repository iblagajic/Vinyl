//
//  UITapGestureRecognizer+UILabel.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 03/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    
    func didTap(oneOf texts: [String]) -> String? {
        guard let textView = view as? UITextView,
            let attributedText = textView.attributedText else { return nil }
        let rangesAndTexts = texts.map { text -> (NSRange, String) in
            let range = (attributedText.string as NSString).range(of: text)
            return (range, text)
        }
        
        let layoutManager = textView.layoutManager
        
        let locationOfTouchInLabel = location(in: textView)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInLabel, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let index = String.Index(utf16Offset: indexOfCharacter, in: attributedText.string)
        let tappedCharacter = attributedText.string[index]
        print(tappedCharacter)
        
        return rangesAndTexts.filter { (range, _) in
            return NSLocationInRange(indexOfCharacter, range)
        }.first?.1
    }
    
}
