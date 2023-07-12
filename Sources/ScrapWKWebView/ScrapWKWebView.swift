//
//  WebViewController.swift
//  smartvoca
//
//  Created by Victor Choi on 6/14/23.
//

import UIKit
import SwiftUI
import WebKit

protocol ScrapWKWebViewDelegate {
    func getHTML(html: String)
}

@available(iOS 13.0, *)
struct ScrapWKWebView: UIViewControllerRepresentable {
    typealias UIViewControllerType = WKWebViewController
    var url: String
    var getHTML: (_ html: String) -> Void
    var timeout: Double = 2.0
    
    class Coordinator: NSObject, ScrapWKWebViewDelegate {
        func getHTML(html: String) {
            self.parent.getHTML(html)
        }
        
        var parent: ScrapWKWebView
        
        init(parent: ScrapWKWebView) {
            self.parent = parent
        }
    }
    
    func makeUIViewController(context: Context) -> WKWebViewController {
        let vc = WKWebViewController()
        vc.delegate = context.coordinator
        vc.timeout = timeout
        vc.webURL = url
        return vc
    }
    
    func updateUIViewController(_ uiViewController: WKWebViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}
