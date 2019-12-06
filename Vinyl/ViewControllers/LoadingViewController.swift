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
    
    private let activityIndicatorView = ActivityIndicatorView()
    private var activityIndicatorCenterY = NSLayoutConstraint()
    private let errorTitleLabel = UILabel.block
    private let errorMessageLabel = UITextView.header
    private let cancelButton = UIButton.cancel
    private var contentView = UIView(forAutoLayout: ())
    private let loadingView = UIStackView(forAutoLayout: ())
    let bag = DisposeBag()
        
    func handleObservable<T>(observable: Observable<T>) -> Observable<T> {
        return rx.viewDidLoad.flatMap { observable.timeout(.seconds(3), scheduler: MainScheduler.instance) }
            .catchError { error in
                guard let rxError = error as? RxError else {
                    return Observable.error(error)
                }
                switch rxError {
                case .timeout:
                    return Observable.error(DiscogsError.unavailable)
                default:
                    return Observable.error(error)
                }
            }.observeOn(MainScheduler.instance)
            .retryWhen(errorHandler)
            .do(onNext: { [weak self] _ in
                self?.navigationItem.hidesBackButton = false
                self?.contentView.isHidden = false
                self?.loadingView.isHidden = true
            })
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
                errorTitle = .genericErrorTitle
                errorMessage = .genericErrorMessage
            case .noResults:
                errorTitle = .noResultsErrorTitle
                errorMessage = .noResultsErrorMessage
            case .unavailable:
                errorTitle = .connectionErrorTitle
                errorMessage = String(format: .connectionErrorMessage, String.retry)
                highlightPart = .retry
            }
        } else {
            errorTitle = .genericErrorTitle
            errorMessage = .genericErrorMessage
        }
        errorTitleLabel.text = errorTitle
        errorMessageLabel.set(headerText: errorMessage, highlightPart: highlightPart)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        errorMessageLabel.addGestureRecognizer(tapGestureRecognizer)
        errorMessageLabel.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.cancelButton.alpha = 1
            self?.activityIndicatorView.alpha = 0
            self?.errorTitleLabel.isHidden = false
            self?.errorMessageLabel.isHidden = false
        }
        let close = cancelButton.rx.tap.flatMap { _ -> Observable<Void> in Observable.error(error) }
        let retry = tapGestureRecognizer.rx.event.map { $0.didTap(oneOf: [.retry]) }.flatMap { _ in Observable.just(()) }
            .do(onNext: {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.cancelButton.alpha = 0
                    self?.activityIndicatorView.alpha = 1
                    self?.errorTitleLabel.isHidden = true
                    self?.errorMessageLabel.isHidden = true
                }
            }).delay(.milliseconds(500), scheduler: MainScheduler.instance)
        return Observable.merge(close, retry)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.image = .vinyl
        activityIndicatorView.tintColor = .dark
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: bag)
        navigationItem.hidesBackButton = true
    }
    
    override func loadView() {
        let root = UIView.whiteBackground
        loadingView.axis = .vertical
        loadingView.spacing = 22
        let activityAndClose = UIView(forAutoLayout: ())
        [activityIndicatorView, cancelButton].forEach(activityAndClose.addSubview)
        [errorTitleLabel, errorMessageLabel, activityAndClose].forEach(loadingView.addArrangedSubview)
        
        errorTitleLabel.isHidden = true
        errorMessageLabel.isHidden = true
        
        self.contentView = setupContentView()
        
        [contentView, loadingView].forEach(root.addSubview)
        
        loadingView.centerXAnchor.constraint(equalTo: root.centerXAnchor).isActive = true
        activityIndicatorCenterY = loadingView.centerYAnchor.constraint(equalTo: root.centerYAnchor)
        activityIndicatorCenterY.isActive = true
        loadingView.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 44).isActive = true
        activityAndClose.heightAnchor.constraint(equalToConstant: 99).isActive = true
        cancelButton.topAnchor.constraint(equalTo: activityAndClose.topAnchor, constant: 22).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: activityAndClose.bottomAnchor).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: activityAndClose.centerXAnchor).isActive = true
        activityIndicatorView.pin(to: cancelButton)
        
        self.view = root
        
        contentView.isHidden = true
        cancelButton.alpha = 0
    }
    
    func setupContentView() -> UIView { return UIView() }
}
