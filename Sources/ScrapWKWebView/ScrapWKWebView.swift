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
public struct ScrapWKWebView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = WKWebViewController
    var url: String
    var getHTML: (_ html: String) -> Void
    var timeout: Double = 2.0
    
    public init(url: String, getHTML: @escaping (_: String) -> Void, timeout: Double) {
        self.url = url
        self.getHTML = getHTML
        self.timeout = timeout
    }
    
    public class Coordinator: NSObject, ScrapWKWebViewDelegate {
        func getHTML(html: String) {
            self.parent.getHTML(html)
        }
        
        var parent: ScrapWKWebView
        
        init(parent: ScrapWKWebView) {
            self.parent = parent
        }
    }
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        let vc = WKWebViewController()
        vc.delegate = context.coordinator
        vc.timeout = timeout
        vc.webURL = url
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}
