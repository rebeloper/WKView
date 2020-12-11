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
           case decidePolicy(WKNavigationAction, WKNavigationActionPolicy) //mandatory
           case didRecieveAuthChallenge(URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) //mandatory
           case didStartProvisionalNavigation(WKNavigation)
           case didReceiveServerRedirectForProvisionalNavigation(WKNavigation)
           case didCommit(WKNavigation)
           case didFinish(WKNavigation)
           case didFailProvisionalNavigation(WKNavigation, Error)
           case didFail(WKNavigation, Error)
       }
       
    @ObservedObject var webViewStateModel: WebViewStateModel
    
    private var actionDelegate: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?
    
    let uRLRequest: URLRequest
    
    let allowedHosts: [String]?
    let forbiddenHosts: [String]?
    let credential: URLCredential?
    
    public var body: some View {
        
        WebViewWrapper(webViewStateModel: webViewStateModel,
                       request: uRLRequest,
                       action: actionDelegate,
                       allowedHosts: allowedHosts,
                       forbiddenHosts: forbiddenHosts,
                       credential: credential)
    }
    
    init(uRLRequest: URLRequest, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?, allowedHosts: [String]?, forbiddenHosts: [String]?, credential: URLCredential?) {
        self.uRLRequest = uRLRequest
        self.webViewStateModel = webViewStateModel
        self.actionDelegate = onNavigationAction
        self.allowedHosts = allowedHosts
        self.forbiddenHosts = forbiddenHosts
        self.credential = credential
    }
    
    init(url: URL, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?, allowedHosts: [String]?, forbiddenHosts: [String]?, credential: URLCredential?) {
        self.init(uRLRequest: URLRequest(url: url),
                  webViewStateModel: webViewStateModel,
                  onNavigationAction: onNavigationAction,
                  allowedHosts: allowedHosts,
                  forbiddenHosts: forbiddenHosts,
                  credential: credential)
    }
}

