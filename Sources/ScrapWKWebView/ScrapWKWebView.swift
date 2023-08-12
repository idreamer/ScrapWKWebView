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
    public typealias HTMLClosure = (_ html: String) -> Void
    
    var url: String
    var showWebView = false
    var getHTML: HTMLClosure?
    var timeout: Double = 2.0
    
    public init(url: String, showWebView: Bool) {
        self.url = url
        self.showWebView = showWebView
    }
    
    public init(url: String, showWebView: Bool = false, getHTML: @escaping HTMLClosure, timeout: Double) {
        self.url = url
        self.getHTML = getHTML
        self.timeout = timeout
        self.showWebView = showWebView
    }
    
    public class Coordinator: NSObject, ScrapWKWebViewDelegate {
        func getHTML(html: String) {
            guard let getHTML = self.parent.getHTML else { return }
            getHTML(html)
        }
        var parent: ScrapWKWebView
        init(parent: ScrapWKWebView) {
            self.parent = parent
        }
    }
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        let vc = WKWebViewController()
        if !showWebView {
            vc.delegate = context.coordinator
        }
        vc.timeout = timeout
        vc.webURL = url
        vc.showWebView = showWebView
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.webURL = url
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}
