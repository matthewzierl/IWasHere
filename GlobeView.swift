//
//  GlobeView.swift
//  IWasHere
//
//  Created by Matthew Zierl on 5/13/24.
//  Copyright © 2024 matthewzierl.org. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleMaps

class GlobeView: UIViewController, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    
    override func loadView() {
        let camera:GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 35.67, longitude: 139.65, zoom: 12)
        let mapID = GMSMapID(identifier: "edb7acdc18a8f201")
        mapView = GMSMapView(frame: .zero, mapID: mapID, camera: camera)
        self.view = mapView
        mapView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a single marker with a custom icon
        let mapCenter = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
        let marker = GMSMarker(position: mapCenter)
        marker.icon = UIImage(named: "custom_pin.png")
        marker.map = mapView
        
    }
}

struct GlobeViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = GlobeView()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        return
    }
    
    typealias UIViewControllerType = UIViewController
}

//#Preview {
//    GlobeView()
//}
