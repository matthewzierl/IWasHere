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
import CoreLocation
import SwiftProtobuf
import FirebaseFirestore
import FirebaseStorage

class ViewController: UIViewController, CLLocationManagerDelegate {
    var session: AVCaptureSession? // capture session
    let output = AVCapturePhotoOutput() // photo output
    let previewLayer = AVCaptureVideoPreviewLayer() // video preview
    private var imageView: UIImageView? // image view for captured photo
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
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
        button.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.isHidden = true // initially hidden
        return button
    }()
    
    // Send button
    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 40)
        button.isHidden = true // initially hidden
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(closeButton)
        view.addSubview(uploadButton)
        
        view.addSubview(photoLabel)
        
        checkCameraPermissions()
        setupLocationManager()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(didTapUpload), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - 100)
        closeButton.center = CGPoint(x: 20, y: 30)
        uploadButton.center = CGPoint(x: view.frame.size.width - 60, y: view.frame.size.height - 60)
        photoLabel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50)
        photoLabel.center = view.center
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
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
    
    private func savePhotoMetadata(_ data: Data) {
        let db = Firestore.firestore()
        let photoCollection = db.collection("photos")
        
        photoCollection.addDocument(data: ["metadata": data]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    private func uploadImageToFirebase(_ imageData: Data, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                        completion(nil)
                    } else {
                        completion(url)
                    }
                }
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
        uploadButton.isHidden = true // Hide the upload button
        photoLabel.isHidden = true // Hide the photo label
        DispatchQueue.global(qos: .userInitiated).async {
            self.session?.startRunning() // Restart the camera session
        }
    }
    
    @objc private func didTapUpload() {
        guard let imageView = imageView, let image = imageView.image, let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }

        uploadImageToFirebase(imageData) { [weak self] url in
            guard let self = self, let url = url else {
                return
            }
            
            // Serialize the photo metadata
            if let location = self.currentLocation {
                let photoMetadata = Photo.with {
                    $0.latitude = location.coordinate.latitude
                    $0.longitude = location.coordinate.longitude
                    $0.timestamp = Int64(Date().timeIntervalSince1970)
                    $0.imageURL = url.absoluteString
                    $0.notes = "" // Add user notes if applicable
                }

                do {
                    let serializedData = try photoMetadata.serializedData()
                    // Save `serializedData` to Firestore
                    self.savePhotoMetadata(serializedData)
                } catch {
                    print("Failed to serialize photo metadata: \(error)")
                }
            }
            
            self.uploadButton.isHidden = true
            self.didTapClose()
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
                self.view.bringSubviewToFront(self.uploadButton)
                self.photoLabel.isHidden = false
                self.closeButton.isHidden = false // Show the close button
                self.uploadButton.isHidden = false
            }
        }
    }
}

/*
 Conforms UIKit view to SwiftUI view
 */
struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        return
    }
}
