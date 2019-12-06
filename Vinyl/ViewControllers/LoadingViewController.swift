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
    private var contentView = UIView(forAutoLayout: ())
    let bag = DisposeBag()
        
    func handleObservable<T>(observable: Observable<T>) -> Observable<T> {
        return observable.timeout(.seconds(3), scheduler: MainScheduler.instance)
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
            .do(onNext: { [unowned self] _ in
                self.navigationItem.hidesBackButton = false
                self.contentView.isHidden = false
                self.activityIndicatorView.isHidden = true
            }, onError: { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            })
    }
    
    private func errorHandler(errorObservable: Observable<Error>) -> Observable<Void> {
        return errorObservable.flatMap(showNetworkError)
    }
    
    private func showNetworkError(error: Error) -> Single<Void> {
        var errorTitle: String
        var errorMessage: String
        var canRetry: Bool
        if let discogsError = error as? DiscogsError {
            switch discogsError {
            case .invalidUrl:
                errorTitle = .genericErrorTitle
                errorMessage = .genericErrorMessage
                canRetry = false
            case .noResults:
                errorTitle = .noResultsErrorTitle
                errorMessage = .noResultsErrorMessage
                canRetry = false
            case .unavailable:
                errorTitle = .connectionErrorTitle
                errorMessage = .connectionErrorMessage
                canRetry = true
            }
        } else {
            errorTitle = .genericErrorTitle
            errorMessage = .genericErrorMessage
            canRetry = false
        }
        var actions = [UIAlertController.AlertAction.dismiss]
        if canRetry {
            actions.append(.retry { [activityIndicatorView] _ in
                activityIndicatorView.isHidden = false
            })
        }
        return presentAlertController(
            withTitle: errorTitle,
            message: errorMessage,
            actions: actions
        ).flatMap { action -> Single<Void> in
            if action.identifier == .dismiss {
                return .error(error)
            } else {
                return .just(())
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.image = .vinyl
        activityIndicatorView.tintColor = .dark
        navigationItem.hidesBackButton = true
    }
    
    override func loadView() {
        let root = UIView.whiteBackground
        
        self.contentView = setupContentView()
        
        [contentView, activityIndicatorView].forEach(root.addSubview)
        
        activityIndicatorView.centerInSuperview()
        
        self.view = root
        
        contentView.isHidden = true
    }
    
    func setupContentView() -> UIView { return UIView() }
}
