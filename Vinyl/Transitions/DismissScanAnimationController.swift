//
//  DismissScanAnimationController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class DismissScanAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.8
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVc = transitionContext.viewController(forKey: .from) as? ScanViewController,
            let toVc = transitionContext.viewController(forKey: .to) as? HomeViewController,
            let toGreeting = toVc.greetingLabel.snapshotView(afterScreenUpdates: true),
            let fromScan = fromVc.scanLabel.snapshotView(afterScreenUpdates: true),
            let toOrSearch = toVc.orSearchLabel.snapshotView(afterScreenUpdates: true),
            let toCamera = toVc.cameraButton.snapshotView(afterScreenUpdates: true) else {
                return
        }
        
        let background = UIView.background
        
        [toGreeting, fromScan, toOrSearch, toCamera].forEach(transitionContext.containerView.addSubview)
        transitionContext.containerView.insertSubview(toVc.view, belowSubview: fromVc.view)
        transitionContext.containerView.insertSubview(background, belowSubview: fromVc.view)
        
        toGreeting.frame = toVc.greetingLabel.frame
        toGreeting.alpha = 0
        fromScan.frame = fromVc.scanLabel.frame
        toOrSearch.frame = toVc.orSearchLabel.frame
        toCamera.frame = toVc.cameraButton.frame
        
        let yTranslation = toVc.scanLabel.frame.minY - fromScan.frame.minY
        
        toGreeting.transform = CGAffineTransform(translationX: 0, y: -yTranslation/2)
        toOrSearch.transform = CGAffineTransform(translationX: 0, y: -yTranslation*5/4)
        toCamera.transform = CGAffineTransform(translationX: 0, y: -yTranslation*3/2)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration/4, delay: 0, animations: {
            fromVc.view.alpha = 0
        })
        
        UIView.animate(withDuration: duration/2, delay: duration/4, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            toGreeting.transform = .identity
            toGreeting.alpha = 1
            fromScan.transform = CGAffineTransform(translationX: 0, y: yTranslation)
            toOrSearch.transform = .identity
            toCamera.transform = .identity
        })
        
        UIView.animate(withDuration: duration/4, delay: duration*3/4, animations: {
            background.alpha = 0
        }){ _ in
            background.removeFromSuperview()
            toGreeting.removeFromSuperview()
            fromScan.removeFromSuperview()
            toOrSearch.removeFromSuperview()
            toCamera.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
