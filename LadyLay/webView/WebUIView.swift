//
//  WebUIView.swift
//  DailyApp
//
//  Created by Ebrar Gül on 21.06.2024.
//
import Foundation
import SwiftUI

struct WebUIView: View {
    var url: String
    var title: String
    
    @State private var loaded = false
    
    var body: some View {
        ZStack {
            if !loaded {
                ActivityIndicator(style: .medium)
            }
           // WebViewWrapper(loaded: self.$loaded, url: URL(string: url))
            //    .navigationBarTitle(Text(title.localized()), displayMode: .inline)
        }
    }
}

