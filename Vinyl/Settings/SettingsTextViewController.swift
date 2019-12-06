//
//  SettingsTextViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 07/12/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import MessageUI

struct Link {
    let text: String
    let kind: Kind

    enum Kind {
        case url(URL)
        case email(String)
    }

    init?(text: String, path: String) {
        guard let url = URL(string: path) else {
            return nil
        }
        self.text = text
        self.kind = .url(url)
    }

    init?(text: String, email: String) {
        self.text = text
        self.kind = .email(email)
    }
}

class SettingsTextViewController: UIViewController {

    private let bag = DisposeBag()
    private let textView = UITextView(forAutoLayout: ())

    required init(with bodyText: String, tappableParts: [Link], boldPart: String?, title: String) {
        super.init(nibName: nil, bundle: nil)

        let tappableStrings = tappableParts.map { $0.text }
        textView.set(bodyText: bodyText, boldPart: boldPart, underlineParts: tappableStrings)
        textView.didTap(oneOf: tappableStrings)
            .flatMap { [weak self] tappedText -> Observable<(MFMailComposeResult?, URL?)> in
                let optionalLink = tappableParts.first(where: { $0.text == tappedText })
                guard let link = optionalLink else {
                    return .just((nil, nil))
                }
                switch link.kind {
                case .email(let recipient):
                    guard MFMailComposeViewController.canSendMail() else {
                        return Observable.just((.failed, nil))
                    }
                    let mailComposeViewController = MFMailComposeViewController()
                    mailComposeViewController.setToRecipients([recipient])
                    self?.present(mailComposeViewController, animated: true)
                    return mailComposeViewController.rx.didFinishWithResult.map { ($0, nil) }
                case .url(let url):
                    return .just((nil, url))
                }
            }.subscribe(onNext: { [unowned self] (mailResult, url) in
                if let url = url {
                    UIApplication.shared.open(url, options: [:])
                } else if let result = mailResult {
                    switch result {
                    case .cancelled:
                        self.dismiss(animated: true)
                    case .failed:
                        self.dismiss(animated: true) {
                            self.showSendMailErrorAlert()
                        }
                    case .saved,
                         .sent:
                        self.dismiss(animated: true) {
                            self.showSendMailSuccessAlert()
                        }
                    @unknown default:
                        self.showSendMailErrorAlert()
                    }
                }
        }).disposed(by: bag)

        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let root = UIView.whiteBackground
        root.addSubview(textView)
        textView.pinToSuperview()
        self.view = root
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = .body
        textView.textColor = .dark
        textView.contentInset = UIEdgeInsets(top: 0, left: .margin*2, bottom: .margin*2, right: .margin*2)
    }

    private func showSendMailErrorAlert() {
        let alert = UIAlertController(title: .emailErrorTitle,
                                      message: .emailErrorMessage,
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: .dismiss, style: .default)
        alert.addAction(dismissAction)
        let copyAction = UIAlertAction(title: .copyToClipboard, style: .default) { _ in
            UIPasteboard.general.string = .email
        }
        alert.addAction(copyAction)
        present(alert, animated: true)
    }

    private func showSendMailSuccessAlert() {
        let alert = UIAlertController(title: .emailSuccessTitle,
                                      message: .emailSuccessMessage,
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: .emailSuccessDismiss, style: .default)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}
