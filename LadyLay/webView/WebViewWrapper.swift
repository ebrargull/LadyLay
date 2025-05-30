//
//  WebViewWrapper.swift
//  Daily-App-1
//
//  Created by Ebrar Gül on 25.06.2024.
//

import SwiftUI
import Foundation
import WebKit

struct WebViewWrapper: UIViewRepresentable {
    @Binding var loaded: Bool
    
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: .zero)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let _url = url {
            let urlRequest = URLRequest(url: _url)
            uiView.load(urlRequest)
            uiView.isOpaque = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(webView: self, loaded: $loaded)
    }
}

internal extension WebViewWrapper {
    final class Coordinator: NSObject, WKNavigationDelegate {
        let webView: WebViewWrapper
        @Binding var loaded: Bool
        
        init(webView: WebViewWrapper, loaded: Binding<Bool>) {
            self.webView = webView
            _loaded = loaded
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("finishpage")
            self.loaded = true
        }
    }
}

