//
//  PageControl.swift
//  SCS
//
//  Created by Serge Creator Studios on 09.02.2023.
//

import SwiftUI
import UIKit

struct PageControl: UIViewRepresentable {
    
    // MARK: - Properties
    
    @Binding var current: Int
    var amount: Int
    
    // MARK: - Make
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = amount
        control.addTarget(context.coordinator, action: #selector(Coordinator.update(sender:)), for: .valueChanged)
        return control
    }
    
    // MARK: - Update
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = current
    }
    
    // MARK: - Coordinator
    
    final class Coordinator: NSObject {
        var control: PageControl
        
        init(_ control: PageControl) {
            self.control = control
        }
        
        /// Updates current page.
        @objc func update(sender: UIPageControl) {
            control.current = sender.currentPage
        }
    }
}
