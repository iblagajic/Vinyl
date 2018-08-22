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
    
    let infoButton = UIButton.info
    let greetingLabel = UILabel.block
    let scanLabel = UILabel.header
    let orSearchLabel = UILabel.header
    let cameraButton = UIButton.camera
    private let navigationControllerDelegate = NavigationControllerDelegate()
    private let bag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        cameraButton.rx.tap.subscribe(onNext: { [weak self] in
            let scanViewController = ScanViewController()
            self?.navigationController?.pushViewController(scanViewController, animated: true)
        }).disposed(by: bag)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            let searchViewController = SearchViewController()
            self?.navigationController?.pushViewController(searchViewController, animated: true)
        }).disposed(by: bag)
        orSearchLabel.addGestureRecognizer(tapGesture)
        orSearchLabel.isUserInteractionEnabled = true
        infoButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.pushViewController(InfoViewController(), animated: true)
        }).disposed(by: bag)
    }
    
    override func loadView() {
        let root = UIView.background
        
        [infoButton, greetingLabel, scanLabel, orSearchLabel, cameraButton].forEach(root.addSubview)
        
        infoButton.topAnchor.constraint(equalTo: root.safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
        infoButton.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 44).isActive = true
        greetingLabel.leadingAnchor.constraint(equalTo: scanLabel.leadingAnchor).isActive = true
        scanLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 22).isActive = true
        scanLabel.leadingAnchor.constraint(equalTo: infoButton.leadingAnchor).isActive = true
        scanLabel.centerYAnchor.constraint(equalTo: root.centerYAnchor, constant: -50).isActive = true
        orSearchLabel.topAnchor.constraint(equalTo: scanLabel.bottomAnchor, constant: 3).isActive = true
        orSearchLabel.leadingAnchor.constraint(equalTo: scanLabel.leadingAnchor).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: root.safeAreaLayoutGuide.bottomAnchor, constant: -66).isActive = true
        cameraButton.centerXAnchor.constraint(equalTo: root.centerXAnchor).isActive = true
        
        self.view = root
        
        greetingLabel.text = String.welcome.uppercased()
        scanLabel.set(headerText: .scan)
        let scanString = .or + " " + .search
        orSearchLabel.set(headerText: scanString, highlightPart: .search)
    }
}
