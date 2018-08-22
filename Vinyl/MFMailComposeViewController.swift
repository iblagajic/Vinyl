//
//  MFMailComposeViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 04/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import RxSwift
import RxCocoa
import MessageUI

enum MailError: Error {
    case notAvailable
}

class RxMailComposeViewControllerDelegateProxy
    : DelegateProxy<MFMailComposeViewController, MFMailComposeViewControllerDelegate>
    , DelegateProxyType
, MFMailComposeViewControllerDelegate {
    
    static func currentDelegate(for object: MFMailComposeViewController) -> MFMailComposeViewControllerDelegate? {
        return object.mailComposeDelegate
    }
    
    static func setCurrentDelegate(_ delegate: MFMailComposeViewControllerDelegate?, to object: MFMailComposeViewController) {
        object.mailComposeDelegate = delegate
    }
    
    
    /// Typed parent object.
    weak private(set) var mailComposeViewController: MFMailComposeViewController?
    
    init(mailComposeViewController: ParentObject) {
        self.mailComposeViewController = mailComposeViewController
        super.init(parentObject: mailComposeViewController, delegateProxy: RxMailComposeViewControllerDelegateProxy.self)
    }
    
    // Register known implementationss
    static func registerKnownImplementations() {
        self.register { RxMailComposeViewControllerDelegateProxy(mailComposeViewController: $0) }
    }
}

extension Reactive where Base: MFMailComposeViewController {
    
    /**
     Reactive wrapper for `delegate`.
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    var mailComposeDelegate: DelegateProxy<MFMailComposeViewController, MFMailComposeViewControllerDelegate> {
        return RxMailComposeViewControllerDelegateProxy.proxy(for: base)
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    var didFinishWithResult: ControlEvent<MFMailComposeResult> {
        let source: Observable<MFMailComposeResult> = mailComposeDelegate
            .methodInvoked(#selector(MFMailComposeViewControllerDelegate.mailComposeController(_:didFinishWith:error:)))
            .map { arg in
                let result = MFMailComposeResult(rawValue: arg[1] as! Int)!
                return (result)
        }
        return ControlEvent(events: source)
    }
    
}
