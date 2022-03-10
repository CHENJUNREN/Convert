//
//  WebView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/3/8.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: self.url) else { return }
        uiView.load(URLRequest(url: url))
    }
}
