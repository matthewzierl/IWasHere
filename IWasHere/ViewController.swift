//
//  ViewController.swift
//  IWasHere
//
//  Created by Matthew Zierl on 5/12/24.
//  Copyright © 2024 matthewzierl.org. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

class ViewController: UIViewController {
    /**
     For camera:
        - Catpure Session
        - Photo Output
        - Video Preview
        - Shutter Button
     */
    
    var session: AVCaptureSession? // capture session
    
    let output = AVCapturePhotoOutput() // photo output
    
    let previewLayer = AVCaptureVideoPreviewLayer() // Video preview
    
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 110)
    }
    
    /*
     checkCameraPermissions checks whether use allowed for camera to be used
     
     if authorized, calls setUpCamera()
     */
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                // "[weak self]" captures self weakly meaning it holds a 'weak' reference to the object
                // it belongs to. if object becomes deallocated, ends up being nil (good mem management)
                if granted {
                    DispatchQueue.main.async {
                        self?.setUpCamera()
                    }
                }
                else {
                    return
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let new_session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if new_session.canAddInput(input) {
                    new_session.addInput(input)
                }
                
                if new_session.canAddOutput(output) {
                    new_session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = new_session
                
                new_session.startRunning()
                self.session = new_session
            }
            catch {
                print(error)
            }
        }
    }
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        let image = UIImage(data: data)
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}
