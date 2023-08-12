//
//  WKWebViewController.swift
//  smartvoca
//
//  Created by Victor Choi on 6/14/23.
//

import UIKit
import WebKit


let MESSAGE_HANDLER_NAME = "WKWebViewMessageHandler"

public final class WKWebViewController: UIViewController {
    var delegate: ScrapWKWebViewDelegate?
    var timeout: Double = 2.0
    var webView: WKWebView!
    var isScrappingWebView = true
    
    var webURL: String = "" {
        didSet {
            let url = URL(string: self.webURL)!
            self.webView.load(URLRequest(url: url))
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.webView = {
            let webConfiguration = WKWebViewConfiguration()
            
            if isScrappingWebView {
                let wkUserController = WKUserContentController()
                wkUserController.add(self, name: MESSAGE_HANDLER_NAME)
                webConfiguration.userContentController = wkUserController
            }
            let webView = WKWebView(frame: .zero, configuration: webConfiguration)
            
            if #available(iOS 16.4, *) {
                webView.isInspectable = true
            }
            webView.navigationDelegate = self
            return webView
        }()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        if !isScrappingWebView {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
}

extension WKWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript = """
        var outerHTML = document.documentElement.outerHTML.toString();
        var message = {"type": "outerHTML", "outerHTML": outerHTML };
        window.webkit.messageHandlers.\(MESSAGE_HANDLER_NAME).postMessage(message);
        """
        
        Timer.scheduledTimer(withTimeInterval: self.timeout, repeats: false) { _ in
            self.evaluateJavascript(javascript, sourceURL: "getOuterHTML") { error in
                print("javascript error: \(error)")
            }
        }
    }
    
    private func evaluateJavascript(_ javascript: String, sourceURL: String? = nil, completion: ((_ error: String) -> Void)? = nil) {
        var javascript = javascript
        if let sourceURL = sourceURL {
            javascript = "// # sourceURL=\(sourceURL).js\n" + javascript
        }
        
        self.webView.evaluateJavaScript(javascript) { _, error in
            completion?(error?.localizedDescription ?? "")
        }
    }
}

extension WKWebViewController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any] else {
            print("could not convert message body to dictionary: \(message.body)")
            return
        }
        guard let type = body["type"] as? String else {
            print("could not convert body[\"type\"] to string: \(body)")
            return
        }
        
        switch type {
        case "outerHTML":
            guard let outerHTML = body["outerHTML"] as? String, let delegate = self.delegate else {
                print("could not convert body[\"outerHTML\"] to string: \(body)")
                return
            }
            delegate.getHTML(html: outerHTML)
        default:
            print("unknown message type \(type)")
            return
        }
    }
}
