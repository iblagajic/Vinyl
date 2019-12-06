//
//  UIImage+Color.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 07/06/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

extension UIColor {
    
    var image: UIImage {
        let scale = UIScreen.main.scale
        let rect = CGRect(x: 0.0, y: 0.0, width: 1/scale, height: 1/scale)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
