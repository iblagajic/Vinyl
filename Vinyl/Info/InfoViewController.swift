//
//  InfoViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 03/08/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MessageUI

class InfoViewController: UIViewController {
    
    let backButton = UIButton.back
    let greetingLabel = UILabel.block
    let thanksGroup = BodyWithTitle(forAutoLayout: ())
    let privacyGroup = BodyWithTitle(forAutoLayout: ())
    let instructionsGroup = BodyWithTitle(forAutoLayout: ())
    let openSourceGroup = BodyWithTitle(forAutoLayout: ())
    let creditsGroup = BodyWithTitle(forAutoLayout: ())
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thanksGroup.bodyLabel.didTap(oneOf: [.discogs])
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://www.discogs.com") else { return }
                UIApplication.shared.open(url, options: [:])
            }).disposed(by: bag)
        
        privacyGroup.bodyLabel.didTap(oneOf: [.email])
            .flatMap { [weak self] _ -> Observable<MFMailComposeResult> in
                guard MFMailComposeViewController.canSendMail() else {
                    return Observable.just(.failed)
                }
                let mailComposeViewController = MFMailComposeViewController()
                mailComposeViewController.setToRecipients([.email])
                self?.present(mailComposeViewController, animated: true)
                return mailComposeViewController.rx.didFinishWithResult.asObservable()
            }.subscribe(onNext: { [weak self] result in
                switch result {
                case .cancelled,
                     .failed:
                    self?.dismiss(animated: true) { [weak self] in
                        self?.showSendMailErrorAlert()
                    }
                case .saved,
                     .sent:
                    self?.dismiss(animated: true) { [weak self] in
                        self?.showSendMailSuccessAlert()
                    }
                }
            }).disposed(by: bag)
        
        let tapGithub = openSourceGroup.bodyLabel.didTap(oneOf: [.github])
            .map { _ in return URL(string: "https://github.com/iblagajic/Vinyl") }
        
        enum Credits {
            case freepik
            case smashicons
            case iconmonstr
            
            var url: URL? {
                switch self {
                case .freepik:
                    return URL(string: "https://www.freepik.com")
                case .smashicons:
                    return URL(string: "https://smashicons.com")
                case .iconmonstr:
                    return URL(string: "https://iconmonstr.com")
                }
            }
        }
        
        let tapCredits = creditsGroup.bodyLabel.didTap(oneOf: [.freepik, .smashicons, .alexanderKahlkopf])
            .map { tappedText -> URL? in
                switch tappedText {
                case .freepik: return Credits.freepik.url
                case .smashicons: return Credits.smashicons.url
                case .alexanderKahlkopf: return Credits.iconmonstr.url
                default: return nil
                }
            }
        
        Observable.merge(tapGithub, tapCredits)
            .subscribe(onNext: { url in
                guard let url = url else { return }
                UIApplication.shared.open(url, options: [:])
            }).disposed(by: bag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
        
        instructionsGroup.bodyLabel.didTap(oneOf: [.catalogNumber]).subscribe(onNext: { _ in
            guard let url = URL(string: "https://ourpastimes.com/catalog-numbers-vinyl-records-8518643.html") else {
                return
            }
            UIApplication.shared.open(url)
        }).disposed(by: bag)
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
    
    override func loadView() {
        let root = UIScrollView(frame: UIScreen.main.bounds)
        root.backgroundColor = .white
        let contentView = UIView(forAutoLayout: ())
        let stackView = UIStackView(forAutoLayout: ())
        stackView.axis = .vertical
        stackView.spacing = 33
        root.addSubview(contentView)
        
        contentView.pinToSuperview()
        contentView.widthAnchor.constraint(equalTo: root.widthAnchor).isActive = true
        
        [backButton, stackView].forEach(contentView.addSubview)
        [greetingLabel, thanksGroup, privacyGroup, instructionsGroup, openSourceGroup, creditsGroup].forEach(stackView.addArrangedSubview)
        
        backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 33).isActive = true
        backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35).isActive = true
        stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 44).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44).isActive = true
        
        self.view = root
        
        greetingLabel.text = .welcome
        thanksGroup.titleLabel.text = .thanks
        let thanksBody = String(format: .about, String.discogs)
        thanksGroup.bodyLabel.set(bodyText: thanksBody, underlineParts: [.discogs])
        privacyGroup.titleLabel.text = .privacyTitle
        let privacyBody = String(format: .privacyMessage, String.privacyMessageHighlighted, String.email)
        privacyGroup.bodyLabel.set(bodyText: privacyBody, boldPart: .privacyMessageHighlighted, underlineParts: [.email])
        instructionsGroup.titleLabel.text = .instructionsTitle
        let instructionsBody = String(format: .instructionsMessage, String.catalogNumber)
        instructionsGroup.bodyLabel.set(bodyText: instructionsBody, underlineParts: [.catalogNumber])
        openSourceGroup.titleLabel.text = .openSourceTitle
        let openSourceBody = String(format: .openSourceMessage, String.github)
        openSourceGroup.bodyLabel.set(bodyText: openSourceBody, underlineParts: [.github])
        creditsGroup.titleLabel.text = .credits
        let creditsBody = String(format: .vinylIcon + "\n" + .cameraIcon + "\n" + .appIcon, String.freepik, String.smashicons, String.alexanderKahlkopf)
        creditsGroup.bodyLabel.set(bodyText: creditsBody, underlineParts: [.freepik, .smashicons, .alexanderKahlkopf])
    }
}
