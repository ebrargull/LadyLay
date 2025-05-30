//
//  ActivityIndicator.swift
//  DailyApp
//
//  Created by Ebrar Gül on 21.06.2024.
//

import SwiftUI
import Foundation

struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext <ActivityIndicator>) ->
    UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context:
                      UIViewRepresentableContext <ActivityIndicator>) {
        uiView.startAnimating()
    }
}
