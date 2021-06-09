//
//  WebPresenterView.swift
//  
//
//  Created by Alex Nagy on 09.12.2020.
//

import SwiftUI
import WebKit

@available(iOS 13.0, *)
public struct WebPresenterView: View {
    public enum NavigationAction {
        case decidePolicy(WKWebView, WKNavigationAction, WKNavigationActionPolicy) //mandatory
        case didRecieveAuthChallenge(WKWebView, URLAuthenticationChallenge, URLSession.AuthChallengeDisposition, URLCredential?) //mandatory
        case didStartProvisionalNavigation(WKWebView, WKNavigation)
        case didReceiveServerRedirectForProvisionalNavigation(WKWebView, WKNavigation)
        case didCommit(WKWebView, WKNavigation)
        case didFinish(WKWebView, WKNavigation)
        case didFailProvisionalNavigation(WKWebView, WKNavigation, Error)
        case didFail(WKWebView, WKNavigation, Error)
    }
    
    @ObservedObject var webViewStateModel: WebViewStateModel
    
    private var actionDelegate: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?
    
    let webViewData: WebViewData
    
    let title: String?
    
    let allowedHosts: [String]?
    let forbiddenHosts: [String]?
    let credential: URLCredential?
    
    public var body: some View {
        WebViewWrapper(
            webViewStateModel: webViewStateModel,
            webViewData: webViewData,
            title: title,
            action: actionDelegate,
            allowedHosts: allowedHosts,
            forbiddenHosts: forbiddenHosts,
            credential: credential
        )
    }
    
    init(
        webViewData: WebViewData,
        webViewStateModel: WebViewStateModel,
        title: String?,
        onNavigationAction: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?,
        allowedHosts: [String]?,
        forbiddenHosts: [String]?,
        credential: URLCredential?
    ) {
        self.webViewData = webViewData
        self.webViewStateModel = webViewStateModel
        self.title = title
        self.actionDelegate = onNavigationAction
        self.allowedHosts = allowedHosts
        self.forbiddenHosts = forbiddenHosts
        self.credential = credential
    }
}

