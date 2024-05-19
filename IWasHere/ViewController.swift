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
    var session: AVCaptureSession? // capture session
    let output = AVCapturePhotoOutput() // photo output
    let previewLayer = AVCaptureVideoPreviewLayer() // video preview
    private var imageView: UIImageView? // image view for captured photo
    
    private let photoLabel: UILabel = {
            let label = UILabel()
            label.text = "Photo captured!"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 20)
            label.textAlignment = .center
            label.numberOfLines = 1
            label.isHidden = true // Initially hidden
            return label
        }()



    // Shutter button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 6
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // Close button
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 20, y: 50, width: 30, height: 30)
        button.isHidden = true // initially hidden
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(closeButton)
        
        view.addSubview(photoLabel)
        
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - 100)
        photoLabel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50)
            photoLabel.center = view.center
    }
    
    // Check camera permissions
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setUpCamera()
                    }
                }
            }
        case .restricted, .denied:
            // Handle restricted or denied permissions
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    // Set up the camera
    private func setUpCamera() {
        let newSession = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if newSession.canAddInput(input) {
                    newSession.addInput(input)
                }
                if newSession.canAddOutput(output) {
                    newSession.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = newSession
                DispatchQueue.global(qos: .userInitiated).async {
                    newSession.startRunning()
                }
                self.session = newSession
            } catch {
                print(error)
            }
        }
    }
    
    // Capture photo
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    // Close photo preview
    @objc private func didTapClose() {
        imageView?.removeFromSuperview() // Remove the image view
        closeButton.isHidden = true // Hide the close button
        photoLabel.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.session?.startRunning() // Restart the camera session
        }
    }
}

// Photo capture delegate
extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        
        let image = UIImage(data: data)
        DispatchQueue.global(qos: .userInitiated).async {
            self.session?.stopRunning()
        }
        
        DispatchQueue.main.async {
            self.imageView = UIImageView(image: image)
            self.imageView?.contentMode = .scaleAspectFill
            self.imageView?.frame = self.view.bounds
            if let imageView = self.imageView { // Checking if not nil
                self.view.addSubview(imageView)
                
                self.view.bringSubviewToFront(self.closeButton)
                self.view.bringSubviewToFront(self.photoLabel)
                self.photoLabel.isHidden = false
                self.closeButton.isHidden = false // Show the close button
                
            }
        }
        
    }
}

/*
 Conforms UIKit view to SwiftUI view
 */
struct CameraView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    /*
     Create view controller object
     Configure it's initial state
     
     return: instance of ViewController
     */
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ViewController()
        // configurations (if needed) here
        
        return vc
    }
    
    /*
     Called when there is an update from SwiftUI
     
     */
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        return
    }
}
