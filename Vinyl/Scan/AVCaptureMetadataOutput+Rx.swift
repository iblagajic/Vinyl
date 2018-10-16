//
//  AVCaptureMetadataOutput+Rx.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVCaptureMetadataOutput {
    
    var delegate: DelegateProxy<AVCaptureMetadataOutput, AVCaptureMetadataOutputObjectsDelegate> {
        return RxAVCaptureMetadataOutputObjectsDelegateProxy.proxy(for: base)
    }
    
    var didOutput: Observable<[AVMetadataObject]> {
        return delegate.methodInvoked(#selector(AVCaptureMetadataOutputObjectsDelegate.metadataOutput(_:didOutput:from:)))
            .map { args in
                let metadataObjects = args[1] as? [AVMetadataObject]
                return metadataObjects ?? []
            }
    }
}
