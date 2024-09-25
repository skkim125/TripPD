//
//  WebView.swift
//  TripPD
//
//  Created by 김상규 on 9/25/24.
//

import SwiftUI
import WebKit

struct PlaceInfoWebView: UIViewRepresentable {
    var urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

