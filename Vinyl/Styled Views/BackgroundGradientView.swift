//
//  BackgroundGradientView.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 06/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class BackgroundGradientView: UIView {
    
    var colors: [CGColor] = [.white, .black] {
        didSet {
            setNeedsDisplay()
        }
    }
    var locations: [CGFloat] = [0.0, 1.0] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else {
            print("Gradient can't be initialized with\ncolorSpace: \(colorSpace),\ncolors: \(colors),\nlocations: \(locations).")
            return
        }
        
        let startPoint = CGPoint(x: bounds.midX, y: 0)
        let endPoint = CGPoint(x: bounds.midX, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
}
