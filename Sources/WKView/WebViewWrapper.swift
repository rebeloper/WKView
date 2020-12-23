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
    let title: String?
    
    let allowedHosts: [String]?
    let forbiddenHosts: [String]?
    let credential: URLCredential?
      
    init(webViewStateModel: WebViewStateModel,
         request: URLRequest,
         title: String?,
         action: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?,
         allowedHosts: [String]?,
         forbiddenHosts: [String]?,
         credential: URLCredential?) {
        self.action = action
        self.request = request
        self.title = title
        self.webViewStateModel = webViewStateModel
        self.allowedHosts = allowedHosts
        self.forbiddenHosts = forbiddenHosts
        self.credential = credential
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
        return Coordinator(action: action, webViewStateModel: webViewStateModel, title: title, allowedHosts: allowedHosts, forbiddenHosts: forbiddenHosts, credential: credential)
    }
    
    final public class Coordinator: NSObject {
        @ObservedObject var webViewStateModel: WebViewStateModel
        let title: String?
        let action: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?
        let allowedHosts: [String]?
        let forbiddenHosts: [String]?
        let credential: URLCredential?
        
        init(action: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?,
             webViewStateModel: WebViewStateModel, title: String?, allowedHosts: [String]?, forbiddenHosts: [String]?, credential: URLCredential?) {
            self.action = action
            let modifiedWebViewStateModel = webViewStateModel
            modifiedWebViewStateModel.pageTitle = title ?? "Loading..."
            self.webViewStateModel = modifiedWebViewStateModel
            self.title = title
            self.allowedHosts = allowedHosts
            self.forbiddenHosts = forbiddenHosts
            self.credential = credential
        }
        
    }
}

@available(iOS 13.0, *)
extension WebViewWrapper.Coordinator: WKNavigationDelegate {
    
    public func handleAllowedHosts(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let allowedHosts = allowedHosts {
            
            if let host = navigationAction.request.url?.host {
                
                var allowed = false
                allowedHosts.forEach { (allowedHost) in
                    if host.contains(allowedHost) {
                        print("WebView -> Found allowed host: \(allowedHost)")
                        allowed = true
                    }
                }
                
                if allowed {
                    decisionHandler(.allow)
                    action?(.decidePolicy(webView, navigationAction, .allow))
                } else {
                    print("WebView -> Did not find allowed hosts for: \(host)")
                    decisionHandler(.cancel)
                    action?(.decidePolicy(webView, navigationAction, .cancel))
                }
            }
            
        } else {
            print("WebView -> No allowed host are set")
            decisionHandler(.allow)
            action?(.decidePolicy(webView, navigationAction, .allow))
        }
    }
    
    public func handleForbiddenHosts(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)  {
        if let forbiddenHosts = forbiddenHosts {
            
            if let host = navigationAction.request.url?.host {
                
                var forbidden = false
                forbiddenHosts.forEach { (forbiddenHost) in
                    if host.contains(forbiddenHost) {
                        print("WebView -> Found forbidden host: \(forbiddenHost)")
                        forbidden = true
                    }
                }
                
                if forbidden {
                    decisionHandler(.cancel)
                    action?(.decidePolicy(webView, navigationAction, .cancel))
                } else {
                    print("WebView -> Did not find forbidden hosts for: \(host)")
                    handleAllowedHosts(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
                }
                
            } else {
                decisionHandler(.cancel)
                action?(.decidePolicy(webView, navigationAction, .cancel))
            }
            
        } else {
            print("WebView -> No forbidden host are set")
            handleAllowedHosts(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        handleForbiddenHosts(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let credential = credential {
            let authenticationMethod = challenge.protectionSpace.authenticationMethod
            if authenticationMethod == NSURLAuthenticationMethodDefault || authenticationMethod == NSURLAuthenticationMethodHTTPBasic || authenticationMethod == NSURLAuthenticationMethodHTTPDigest {
                completionHandler(.useCredential, credential)
                action?(.didRecieveAuthChallenge(webView, challenge, .useCredential, credential))
            } else if authenticationMethod == NSURLAuthenticationMethodServerTrust {
                completionHandler(.performDefaultHandling, nil)
                action?(.didRecieveAuthChallenge(webView, challenge, .performDefaultHandling, nil))
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                action?(.didRecieveAuthChallenge(webView, challenge, .cancelAuthenticationChallenge, nil))
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
            action?(.didRecieveAuthChallenge(webView, challenge, .performDefaultHandling, nil))
        }
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewStateModel.loading = true
        action?(.didStartProvisionalNavigation(webView, navigation))
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        action?(.didReceiveServerRedirectForProvisionalNavigation(webView, navigation))
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        webViewStateModel.canGoForward = webView.canGoForward
        action?(.didFailProvisionalNavigation(webView, navigation, error))
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        action?(.didCommit(webView, navigation))
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        webViewStateModel.canGoForward = webView.canGoForward
        if let title = title {
            webViewStateModel.pageTitle = title
        } else {
            if let title = webView.title {
                webViewStateModel.pageTitle = title
            }
        }
        action?(.didFinish(webView, navigation))
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewStateModel.loading = false
        webViewStateModel.canGoBack = webView.canGoBack
        webViewStateModel.canGoForward = webView.canGoForward
        action?(.didFail(webView, navigation, error))
    }
}


