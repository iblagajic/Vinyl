//
//  PresentLoadingAnimationController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

//class PresentLoadingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    let duration: TimeInterval = 0.8
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromNc = transitionContext.viewController(forKey: .from) as? UINavigationController,
//            let fromVc = fromNc.topViewController as? ScanViewController,
//            let toNc = transitionContext.viewController(forKey: .to) as? UINavigationController,
//            let toVc = toNc.viewControllers.first as? LoadingViewController,
//            let fromSnapshot = fromVc.view.snapshotView(afterScreenUpdates: false) else {
//                return
//        }
//        
//        fromVc.view.isHidden = true
//        transitionContext.containerView.addSubview(toNc.view)
//        toVc.activityIndicatorCenterY.constant = -66
//        toVc.activityIndicatorView.alpha = 0
//        toNc.view.layoutIfNeeded()
//        
//        transitionContext.containerView.addSubview(fromSnapshot)
//        
//        fromSnapshot.frame = fromVc.view.frame
//        
//        let yTranslation = fromVc.view.frame.height
//        
//        let duration = transitionDuration(using: transitionContext)
//        
//        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//            fromSnapshot.transform = CGAffineTransform(translationX: 0, y: yTranslation)
//        }){ _ in
//            fromVc.view.isHidden = false
//            fromSnapshot.removeFromSuperview()
//            transitionContext.completeTransition(true)
//        }
//        
//        toVc.activityIndicatorCenterY.constant = 0
//        UIView.animate(withDuration: duration/2, delay: duration/2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//            toVc.view.layoutIfNeeded()
//            toVc.activityIndicatorView.alpha = 1
//        })
//    }
//}

