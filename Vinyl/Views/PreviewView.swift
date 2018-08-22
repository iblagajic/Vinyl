//
//  PreviewView.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 05/03/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    
    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        videoPreviewLayer?.session = session
        videoPreviewLayer?.videoGravity = .resizeAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? {
        return layer as? AVCaptureVideoPreviewLayer
    }
    
    // MARK: UIView
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
