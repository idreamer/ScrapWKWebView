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
    var isScrappingWebView: Bool = true
    var getHTML: HTMLClosure?
    var timeout: Double = 2.0
    
    public init(url: String, isScrappingWebView: Bool) {
        self.url = url
        self.isScrappingWebView = isScrappingWebView
    }
    
    public init(url: String, isScrappingWebView: Bool = true, timeout: Double = 2.0, getHTML: @escaping HTMLClosure) {
        self.url = url
        self.getHTML = getHTML
        self.timeout = timeout
        self.isScrappingWebView = isScrappingWebView
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
        if isScrappingWebView {
            vc.delegate = context.coordinator
        }
        vc.timeout = timeout
        vc.webURL = url
        vc.isScrappingWebView = isScrappingWebView
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.webURL = url
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}
