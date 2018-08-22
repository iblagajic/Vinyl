//
//  PresentScanAnimationController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class PresentScanAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.8
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVc = transitionContext.viewController(forKey: .from) as? HomeViewController,
            let toVc = transitionContext.viewController(forKey: .to) as? ScanViewController,
            let fromGreeting = fromVc.greetingLabel.snapshotView(afterScreenUpdates: false),
            let fromScan = fromVc.scanLabel.snapshotView(afterScreenUpdates: false),
            let fromOrSearch = fromVc.orSearchLabel.snapshotView(afterScreenUpdates: false),
            let fromCamera = fromVc.cameraButton.snapshotView(afterScreenUpdates: false) else {
                transitionContext.completeTransition(false)
                return
        }
        
        let background = UIView.background
        
        transitionContext.containerView.insertSubview(background, at: 0)
        [fromGreeting, fromScan, fromOrSearch, fromCamera, toVc.view].forEach(transitionContext.containerView.addSubview)
        
        toVc.view.layoutIfNeeded()
        fromVc.view.isHidden = true
        toVc.view.alpha = 0
        
        fromGreeting.frame = fromVc.greetingLabel.frame
        fromScan.frame = fromVc.scanLabel.frame
        fromOrSearch.frame = fromVc.orSearchLabel.frame
        fromCamera.frame = fromVc.cameraButton.frame
        
        let yTranslation = toVc.scanLabel.frame.minY - fromScan.frame.minY
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration*3/4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
            fromGreeting.transform = CGAffineTransform(translationX: 0, y: yTranslation/2)
            fromGreeting.alpha = 0
            fromScan.transform = CGAffineTransform(translationX: 0, y: yTranslation)
            fromOrSearch.transform = CGAffineTransform(translationX: 0, y: yTranslation*5/4)
            fromCamera.transform = CGAffineTransform(translationX: 0, y: yTranslation*3/2)
        })
        
        UIView.animate(withDuration: duration/4, delay: duration*3/4, animations: {
            toVc.view.alpha = 1
        }){ _ in
            fromVc.view.isHidden = false
            background.removeFromSuperview()
            fromGreeting.removeFromSuperview()
            fromScan.removeFromSuperview()
            fromOrSearch.removeFromSuperview()
            fromCamera.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
