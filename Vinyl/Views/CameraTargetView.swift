//
//  CameraTargetView.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 30/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class CameraTargetView: UIView {
    
    override func draw(_ rect: CGRect) {
        let lineSize: CGFloat = 45
        let topLeftPath = UIBezierPath()
        topLeftPath.move(to: CGPoint(x: 0, y: lineSize))
        topLeftPath.addLine(to: .zero)
        topLeftPath.addLine(to: CGPoint(x: lineSize, y: 0))
        topLeftPath.lineWidth = 2
        
        let topRightPath = UIBezierPath()
        topRightPath.move(to: CGPoint(x: rect.maxX - lineSize, y: 0))
        topRightPath.addLine(to: CGPoint(x: rect.maxX, y: 0))
        topRightPath.addLine(to: CGPoint(x: rect.maxX, y: lineSize))
        topRightPath.lineWidth = 2
        
        let bottomRightPath = UIBezierPath()
        bottomRightPath.move(to: CGPoint(x: rect.maxX, y: rect.maxY - lineSize))
        bottomRightPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        bottomRightPath.addLine(to: CGPoint(x: rect.maxX - lineSize, y: rect.maxY))
        bottomRightPath.lineWidth = 2
        
        let bottomLeftPath = UIBezierPath()
        bottomLeftPath.move(to: CGPoint(x: lineSize, y: rect.maxY))
        bottomLeftPath.addLine(to: CGPoint(x: 0, y: rect.maxY))
        bottomLeftPath.addLine(to: CGPoint(x: 0, y: rect.maxY - lineSize))
        bottomLeftPath.lineWidth = 2
        
        UIColor.white.setStroke()
        topLeftPath.stroke()
        topRightPath.stroke()
        bottomRightPath.stroke()
        bottomLeftPath.stroke()
    }
}
