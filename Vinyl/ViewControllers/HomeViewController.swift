//
//  HomeViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    private let scanButton = UIButton.scan
    private let descriptionLabel = UILabel.headlineLightCentered
    fileprivate let settingsButton = UIButton.settings
    fileprivate let searchButton = UIButton.search
    private let bag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        scanButton.rx.tap.subscribe(onNext: { [weak self] in
            let scanViewController = ScanViewController()
            self?.navigationController?.pushViewController(scanViewController, animated: true)
        }).disposed(by: bag)
        navigationItem.titleView = UIImageView(image: .titleLogo)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func loadView() {
        let root = UIView.background
        let centerContainer = UIView.empty
        [scanButton, descriptionLabel].forEach(centerContainer.addSubview)
        
        [centerContainer].forEach(root.addSubview)
        
        self.view = root

        centerContainer.centerInSuperview()
        NSLayoutConstraint.activate([
            scanButton.topAnchor.constraint(equalTo: centerContainer.topAnchor),
            scanButton.centerXAnchor.constraint(equalTo: centerContainer.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 33),
            descriptionLabel.leadingAnchor.constraint(equalTo: centerContainer.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: centerContainer.trailingAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 240),
            descriptionLabel.bottomAnchor.constraint(equalTo: centerContainer.bottomAnchor)
        ])
        
        view.backgroundColor = .dustyOrange
        descriptionLabel.text = .tapToScan
    }
}

enum HomeViewControllerButton {
    case settings
    case search
}

extension Reactive where Base: HomeViewController {
    var tapped: Observable<HomeViewControllerButton> {
        let settingsTap = base.settingsButton.rx.tap.map { HomeViewControllerButton.settings }
        let searchTap = base.searchButton.rx.tap.map { HomeViewControllerButton.search }
        return Observable.merge(settingsTap, searchTap)
    }
}
