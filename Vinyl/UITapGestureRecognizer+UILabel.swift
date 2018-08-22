//
//  UITapGestureRecognizer+UILabel.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 03/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    
    func didTap(text: String) -> Bool {
        guard let textView = view as? UITextView,
            let attributedText = textView.attributedText else { return false }
        let range = (attributedText.string as NSString).range(of: text)
        
        let layoutManager = textView.layoutManager
        
        let locationOfTouchInLabel = location(in: textView)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInLabel, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, range)
    }
    
}
