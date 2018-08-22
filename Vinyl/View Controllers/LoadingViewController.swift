//
//  LoadingViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoadingViewController: UIViewController {
    
    let activityIndicatorView = ActivityIndicatorView()
    var activityIndicatorCenterY = NSLayoutConstraint()
    let errorTitleLabel = UILabel.block
    let errorMessageLabel = UITextView.header
    let closeButton = UIButton.closeLarge
    private let bag = DisposeBag()
    
    init(code: String) {
        super.init(nibName: nil, bundle: nil)
        
        let discogs = Discogs()
        
        let fetchRelease = discogs.search(query: code)
            .flatMap { searchResults -> Observable<Release> in
                guard let firstUrl = searchResults.first?.resource_url else {
                    return Observable.error(DiscogsError.noResults)
                }
                return discogs.fetchRelease(for: firstUrl)
            }
        
        handleObservable(observable: fetchRelease)
    }
    
    init(resourceUrl: String) {
        super.init(nibName: nil, bundle: nil)
        
        let discogs = Discogs()
        
        let fetchRelease = discogs.fetchRelease(for: resourceUrl)
        
        handleObservable(observable: fetchRelease)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func handleObservable(observable: Observable<Release>) {
        observable.timeout(3, scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .retryWhen(errorHandler)
            .subscribe(onNext: { [weak self] release in
                let albumViewController = AlbumViewController(release: release)
                self?.navigationController?.pushViewController(albumViewController, animated: true)
            }).disposed(by: bag)
    }
    
    private func errorHandler(errorObservable: Observable<Error>) -> Observable<Void> {
        return errorObservable.flatMap(showNetworkError)
    }
    
    private func showNetworkError(error: Error) -> Observable<Void> {
        var errorTitle: String
        var errorMessage: String
        var highlightPart: String?
        if let discogsError = error as? DiscogsError {
            switch discogsError {
            case .invalidUrl:
                errorTitle = ""
                errorMessage = ""
            case .noResults:
                errorTitle = .noResultsErrorTitle
                errorMessage = .noResultsErrorMessage
            case .unavailable:
                errorTitle = .connectionErrorTitle
                errorMessage = String(format: .connectionErrorMessage, String.retry)
                highlightPart = .retry
            }
        } else {
            errorTitle = ""
            errorMessage = ""
        }
        errorTitleLabel.text = errorTitle
        errorMessageLabel.set(headerText: errorMessage, highlightPart: highlightPart)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        errorMessageLabel.addGestureRecognizer(tapGestureRecognizer)
        errorMessageLabel.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.closeButton.alpha = 1
            self?.activityIndicatorView.alpha = 0
            self?.errorTitleLabel.isHidden = false
            self?.errorMessageLabel.isHidden = false
        }
        let close = closeButton.rx.tap.flatMap { _ -> Observable<Void> in Observable.error(error) }
        let retry = tapGestureRecognizer.rx.event.map { $0.didTap(oneOf: [.retry]) }.flatMap { _ in Observable.just(()) }
            .do(onNext: {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.closeButton.alpha = 0
                    self?.activityIndicatorView.alpha = 1
                    self?.errorTitleLabel.isHidden = true
                    self?.errorMessageLabel.isHidden = true
                }
            }).delay(0.5, scheduler: MainScheduler.instance)
        return Observable.merge(close, retry)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.image = .vinyl
        activityIndicatorView.tintColor = .dark
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: bag)
    }
    
    override func loadView() {
        let root = UIView.background
        let stackView = UIStackView(forAutoLayout: ())
        stackView.axis = .vertical
        stackView.spacing = 22
        let activityAndClose = UIView(forAutoLayout: ())
        [activityIndicatorView, closeButton].forEach(activityAndClose.addSubview)
        [errorTitleLabel, errorMessageLabel, activityAndClose].forEach(stackView.addArrangedSubview)
        
        errorTitleLabel.isHidden = true
        errorMessageLabel.isHidden = true
        
        root.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: root.centerXAnchor).isActive = true
        activityIndicatorCenterY = stackView.centerYAnchor.constraint(equalTo: root.centerYAnchor)
        activityIndicatorCenterY.isActive = true
        stackView.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 44).isActive = true
        activityAndClose.heightAnchor.constraint(equalToConstant: 99).isActive = true
        closeButton.topAnchor.constraint(equalTo: activityAndClose.topAnchor, constant: 22).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: activityAndClose.bottomAnchor).isActive = true
        closeButton.centerXAnchor.constraint(equalTo: activityAndClose.centerXAnchor).isActive = true
        activityIndicatorView.pin(to: closeButton)
        
        self.view = root
        
        closeButton.alpha = 0
    }
}
