//
//  ScanViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 21/07/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class ScanViewController: UIViewController {
    
    private let backButton = UIButton.back
    private let captureSession = AVCaptureSession()
    let scanLabel = UILabel.header
    private let permissionLabel = UILabel.header
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanLabel.set(headerText: .scan)
        permissionLabel.text = .cameraPermission
        
        if let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device) {
            captureSession.addInput(input)
        }

        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        if metadataOutput.availableMetadataObjectTypes.contains(.ean13) {
            metadataOutput.metadataObjectTypes = [.ean13]
        }
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
        
        metadataOutput.rx.didOutput.map { metadata in
            return metadata.compactMap { $0 as? AVMetadataMachineReadableCodeObject }.first
            }.do(onNext: { [weak self] _ in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self?.captureSession.stopRunning()
            })
            .flatMap { code -> Observable<String> in
                if let codeString = code?.stringValue {
                    return Observable.just(codeString)
                } else {
                    return Observable.error(DiscogsError.noResults)
                }
            }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] code in
                let loadingViewController = LoadingViewController(code: code)
                let navigationController = NavigationController(rootViewController: loadingViewController)
                navigationController.transitioningDelegate = self
                self?.present(navigationController, animated: true)
            }).disposed(by: bag)
        
#if targetEnvironment(simulator)
        let mockBarcodeButton = UIButton(forAutoLayout: ())
        view.addSubview(mockBarcodeButton)
        mockBarcodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mockBarcodeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mockBarcodeButton.setTitle("Mock", for: .normal)
        mockBarcodeButton.setTitleColor(.dark, for: .normal)
        mockBarcodeButton.rx.tap.subscribe(onNext: { [weak self] in
            let loadingViewController = LoadingViewController(code: "0190295643416")
            let navigationController = NavigationController(rootViewController: loadingViewController)
            navigationController.transitioningDelegate = self
            self?.present(navigationController, animated: true)
        }).disposed(by: bag)
#endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning()
        }
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if !granted {
                    self?.permissionLabel.isHidden = false
                }
            }
        } else if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            permissionLabel.isHidden = false
        }
    }
    
    override func loadView() {
        let root = UIView.background
        let previewView = PreviewView(session: captureSession)
        let targetView = CameraTargetView(forAutoLayout: ())
        
        [backButton, previewView, targetView, permissionLabel, scanLabel].forEach(root.addSubview)
        
        backButton.topAnchor.constraint(equalTo: root.safeAreaLayoutGuide.topAnchor, constant: 33).isActive = true
        backButton.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 35).isActive = true
        previewView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 22).isActive = true
        previewView.leadingAnchor.constraint(equalTo: root.leadingAnchor).isActive = true
        previewView.trailingAnchor.constraint(equalTo: root.trailingAnchor).isActive = true
        targetView.heightAnchor.constraint(equalToConstant: 145).isActive = true
        targetView.leadingAnchor.constraint(equalTo: previewView.leadingAnchor, constant: 55).isActive = true
        targetView.centerXAnchor.constraint(equalTo: previewView.centerXAnchor).isActive = true
        targetView.centerYAnchor.constraint(equalTo: previewView.centerYAnchor).isActive = true
        permissionLabel.topAnchor.constraint(equalTo: previewView.topAnchor, constant: 44).isActive = true
        permissionLabel.leftAnchor.constraint(equalTo: scanLabel.leftAnchor).isActive = true
        permissionLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
        scanLabel.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 44).isActive = true
        scanLabel.widthAnchor.constraint(equalToConstant: 287).isActive = true
        scanLabel.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 44).isActive = true
        scanLabel.bottomAnchor.constraint(equalTo: root.safeAreaLayoutGuide.bottomAnchor, constant: -44).isActive = true
        
        self.view = root
        
        permissionLabel.isHidden = true
        previewView.backgroundColor = .steelGrey
        targetView.backgroundColor = .clear
        targetView.layer.shadowColor = UIColor.dark.cgColor
        targetView.layer.shadowOffset = CGSize(width: 1, height: 1)
        targetView.layer.shadowOpacity = 0.9
        targetView.layer.shadowRadius = 3
    }
}

extension ScanViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let presentingNc = presenting as? UINavigationController,
            presentingNc.topViewController?.isKind(of: ScanViewController.self) ?? false,
            let presentedNc = presented as? UINavigationController,
            presentedNc.viewControllers.first?.isKind(of: LoadingViewController.self) ?? false {
            return PresentLoadingAnimationController()
        }
        return nil
    }
}
