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
    
    public var body: some View {
        
        WebViewWrapper(webViewStateModel: webViewStateModel,
                       action: actionDelegate,
                       request: uRLRequest,
                       allowedHosts: allowedHosts)
    }
    
    init(uRLRequest: URLRequest, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)?, allowedHosts: [String]?) {
        self.uRLRequest = uRLRequest
        self.webViewStateModel = webViewStateModel
        self.actionDelegate = onNavigationAction
        self.allowedHosts = allowedHosts
    }
    
    init(url: URL, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebPresenterView.NavigationAction) -> Void)? = nil, allowedHosts: [String]? = nil) {
        self.init(uRLRequest: URLRequest(url: url),
                  webViewStateModel: webViewStateModel,
                  onNavigationAction: onNavigationAction,
                  allowedHosts: allowedHosts)
    }
}

