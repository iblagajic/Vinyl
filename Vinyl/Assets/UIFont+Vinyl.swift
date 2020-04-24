//
//  UIFont+Vinyl.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func regular(size: CGFloat) -> UIFont {
        return loadOrError(fontName: "Lato-Regular", size: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return loadOrError(fontName: "Lato-Bold", size: size)
    }
    
    static func loadOrError(fontName: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError("""
                Failed to load the \(fontName) font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return font
    }
    
    static var body = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.regular(size: 17))
    static var bodyBold = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold(size: 17))
    static var headline = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.bold(size: 19))
    static var largeTitle = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont.bold(size: 34))
    static var metadata = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: UIFont.regular(size: 13))
}
