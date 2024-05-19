//
//  ContentView.swift
//  IWasHere
//
//  Created by Matthew Zierl on 5/12/24.
//

import SwiftUI
import UIKit
import GoogleMaps

struct ContentView: View {
    
    var body: some View {
        // Use TabView to switch between CameraView and GlobeViewRepresentable
                TabView {
                    // CameraView
                    CameraView()
                        .tabItem {
                            Label("Camera", systemImage: "camera")
                        }
                        .tag(0) // Assign a tag for identification
                    
                    // GlobeViewRepresentable
                    GlobeViewRepresentable()
                        .tabItem {
                            Label("Globe", systemImage: "globe")
                        }
                        .tag(1) // Assign a tag for identification
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide tab bar
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Show page indicator
            }
    }



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView()
////        ContentView()
//    }
//}


//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, matt!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
////    ContentView()
////    ImageFeed()
////    GlobeViewRepresentable()
//}
