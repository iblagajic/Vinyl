//
//  UIImage+Multiply.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 02/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIImage{
    
    func multiply(by color: UIColor) -> UIImage{
        let backgroundSize = size
        
        UIGraphicsBeginImageContext(backgroundSize)
        UIGraphicsBeginImageContextWithOptions(backgroundSize, false, UIScreen.main.scale)
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return self
        }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        ctx.setFillColor(red: r, green: g, blue: b, alpha: a)
        
        ctx.beginPath()
        ctx.addArc(center: CGPoint(x: backgroundSize.width/2, y: backgroundSize.height/2), radius: backgroundSize.width/2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        ctx.fillPath()
        
        var imageRect = CGRect()
        imageRect.size = size
        imageRect.origin.x = (backgroundSize.width - size.width)/2
        imageRect.origin.y = (backgroundSize.height - size.height)/2
        
        // Unflip the image
        ctx.translateBy(x: 0, y: backgroundSize.height)
        ctx.scaleBy(x: 1, y: -1)
        
        ctx.setBlendMode(.screen)
        
        guard let cgImage = cgImage else {
            return self
        }
        ctx.draw(cgImage, in: imageRect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
