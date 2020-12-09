//
//  WebViewWrapper.swift
//  
//
//  Created by Alex Nagy on 09.12.2020.
//

import SwiftUI
import WebKit

@available(iOS 13.0, *)
final public class WebViewWrapper : UIViewRepresentable {
    
    @ObservedObject var webViewStateModel: WebViewStateModel
    let action: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?
    
    let request: URLRequest
      
    init(webViewStateModel: WebViewStateModel,
    action: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?,
    request: URLRequest) {
        self.action = action
        self.request = request
        self.webViewStateModel = webViewStateModel
    }
    
    
    public func makeUIView(context: Context) -> WKWebView  {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(request)
        return view
    }
      
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.canGoBack, webViewStateModel.goBack {
            uiView.goBack()
            webViewStateModel.goBack = false
        } else if uiView.canGoForward, webViewStateModel.goForward {
            uiView.goForward()
            webViewStateModel.goForward = false
        } else if webViewStateModel.reload {
            uiView.reload()
            webViewStateModel.reload = false
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(action: action, webViewStateModel: webViewStateModel)
    }
    
    final public class Coordinator: NSObject {
        @ObservedObject var webViewStateModel: WebViewStateModel
        let action: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?
        
        init(action: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?,
             webViewStateModel: WebViewStateModel) {
            self.action = action
            self.webViewStateModel = webViewStateModel
        }
        
    }
}

@available(iOS 13.0, *)
extension WebViewWrapper.Coordinator: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if action == nil {
            decisionHandler(.allow)
        } else {
            action?(.decidePolicy(navigationAction, decisionHandler))
        }
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewStateModel.loading = true
        action?(.didStartProvisionalNavigation(navigation))
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        action?(.didReceiveServerRedirectForProvisionalNavigation(navigation))

    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        webViewStateModel.canGoForward = webView.canGoForward
        action?(.didFailProvisionalNavigation(navigation, error))
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        action?(.didCommit(navigation))
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        webViewStateModel.canGoForward = webView.canGoForward
        if let title = webView.title {
            webViewStateModel.pageTitle = title
        }
        action?(.didFinish(navigation))
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        webViewStateModel.canGoForward = webView.canGoForward
        action?(.didFail(navigation, error))
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if action == nil  {
            completionHandler(.performDefaultHandling, nil)
        } else {
            action?(.didRecieveAuthChallange(challenge, completionHandler))
        }
        
    }
}


