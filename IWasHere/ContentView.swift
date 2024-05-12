//
//  ContentView.swift
//  IWasHere
//
//  Created by Matthew Zierl on 5/12/24.
//

import SwiftUI

/*
 Conforms UIKit view to SwiftUI view
 */
struct myView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    /*
     Create view controller object
     Configure it's initial state
     
     return: instance of ViewController
     */
    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()
        // configurations (if needed) here
        
        return vc
    }
    
    /*
     Called when there is an update from SwiftUI
     
     */
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        return
    }
}

struct ContentView: View {
    var body: some View {
        myView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        myView()
//        ContentView()
    }
}


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
//    ViewController()
//}
