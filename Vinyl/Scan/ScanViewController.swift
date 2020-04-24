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
    
    private let captureSession = AVCaptureSession()
    private let scanLabel = UILabel.body
    private let permissionLabel = UILabel.headline
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = .empty
        
        scanLabel.set(bodyText: .scan)
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
                let albumViewController = AlbumViewController(code: code)
                self?.navigationController?.pushViewController(albumViewController, animated: true)
            }).disposed(by: bag)
        
#if targetEnvironment(simulator)
        let mockBarcodeButton = UIButton(forAutoLayout: ())
        view.addSubview(mockBarcodeButton)
        mockBarcodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mockBarcodeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mockBarcodeButton.setTitle("Mock", for: .normal)
        mockBarcodeButton.setTitleColor(.dark, for: .normal)
        mockBarcodeButton.rx.tap.subscribe(onNext: { [weak self] in
            let albumViewController = AlbumViewController(code: "0190295643416")
            self?.navigationController?.pushViewController(albumViewController, animated: true)
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
        let root = UIView.whiteBackground
        let previewView = PreviewView(session: captureSession)
        let targetView = CameraTargetView(forAutoLayout: ())
        
        [previewView, targetView, permissionLabel, scanLabel].forEach(root.addSubview)
        
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: root.safeAreaLayoutGuide.topAnchor, constant: 22),
            previewView.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            targetView.heightAnchor.constraint(equalToConstant: 145),
            targetView.leadingAnchor.constraint(equalTo: previewView.leadingAnchor, constant: 44),
            targetView.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            targetView.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),
            permissionLabel.topAnchor.constraint(equalTo: previewView.topAnchor, constant: 44),
            permissionLabel.leftAnchor.constraint(equalTo: scanLabel.leftAnchor),
            permissionLabel.widthAnchor.constraint(equalToConstant: 220),
            scanLabel.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 44),
            scanLabel.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 22),
            scanLabel.centerXAnchor.constraint(equalTo: root.centerXAnchor),
            scanLabel.bottomAnchor.constraint(equalTo: root.safeAreaLayoutGuide.bottomAnchor, constant: -44)
        ])
        
        self.view = root
        
        scanLabel.textAlignment = .center
        permissionLabel.isHidden = true
        previewView.backgroundColor = .steelGrey
        targetView.backgroundColor = .clear
        targetView.layer.shadowColor = UIColor.dark.cgColor
        targetView.layer.shadowOffset = CGSize(width: 1, height: 1)
        targetView.layer.shadowOpacity = 0.9
        targetView.layer.shadowRadius = 3
    }
}
