//
//  UIAlertViewController+Rx.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 25/01/2020.
//  Copyright © 2020 Five Dollar Milkshake Limited. All rights reserved.
//

import RxSwift

extension UIAlertController {

    struct AlertAction {
        let title: String?
        let identifier: String?
        let style: UIAlertAction.Style
        let handler: ((UIAlertAction) -> Void)?

        static let dismiss = AlertAction(title: .dismiss, identifier: .dismiss, style: .cancel, handler: nil)
        static func retry(handler: ((UIAlertAction) -> Void)?) -> AlertAction {
            AlertAction(title: .retry, identifier: .retry, style: .default, handler: handler)
        }
    }

    fileprivate static func presentAlertController(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, presenter: UIViewController, actions: [AlertAction]) -> Single<AlertAction> {
        return Single.create { observer -> Disposable in
            let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            actions.forEach { action in
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _alertAction in
                    action.handler?(_alertAction)
                    observer(.success(action))
                }
                controller.addAction(alertAction)
            }
            presenter.present(controller, animated: true)
            return Disposables.create {
                controller.dismiss(animated: true)
            }
        }
    }
}

extension UIViewController {

    func presentAlertController(withTitle title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertController.AlertAction]) -> Single<UIAlertController.AlertAction> {
        return UIAlertController.presentAlertController(withTitle: title, message: message, preferredStyle: preferredStyle, presenter: self, actions: actions)
    }

}
