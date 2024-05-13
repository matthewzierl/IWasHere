//
//  PageViewController.swift
//  IWasHere
//
//  Created by Matthew Zierl on 5/13/24.
//  Copyright © 2024 matthewzierl.org. All rights reserved.
//

import SwiftUI
import UIKit


struct PageViewController<Page: View>: UIViewControllerRepresentable {
    
    var pages: [Page]


    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)


        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
            pageViewController.setViewControllers(
                [UIHostingController(rootView: pages[0])], direction: .forward, animated: true)
    }
}
