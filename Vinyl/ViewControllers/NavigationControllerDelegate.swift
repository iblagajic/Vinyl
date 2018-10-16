//
//  NavigationControllerDelegate.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 31/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC.isKind(of: HomeViewController.self),
            toVC.isKind(of: ScanViewController.self) {
            return PresentScanAnimationController()
        } else if fromVC.isKind(of: ScanViewController.self),
            toVC.isKind(of: HomeViewController.self) {
            return DismissScanAnimationController()
        }
        return nil
    }
    
}
