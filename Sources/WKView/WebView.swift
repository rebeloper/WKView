//
//  WebView.swift
//
//
//  Created by Alex Nagy on 09.12.2020.
//

import SwiftUI
import UIKit
import WebKit

@available(iOS 14.0, *)
public struct WebView: View {
    
    let url: String
    let tintColor: Color
    let backText: Text
    let reloadImage: Image
    let goForwardImage: Image
    let goBackImage: Image
    
    public init(url: String,
         tintColor: Color = .blue,
         titleColor: Color = .black,
         backText: Text = Text("Back"),
         reloadImage: Image = Image(systemName: "gobackward"),
         goForwardImage: Image = Image(systemName: "chevron.forward"),
         goBackImage: Image = Image(systemName: "chevron.backward")) {
        self.url = url
        self.tintColor = tintColor
        self.backText = backText
        self.reloadImage = reloadImage
        self.goForwardImage = goForwardImage
        self.goBackImage = goBackImage
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(titleColor)]
           
    }
    
    @ObservedObject var webViewStateModel: WebViewStateModel = WebViewStateModel()
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        
        LoadingView(isShowing: .constant(webViewStateModel.loading)) {
            WebPresenterView(url: URL.init(string: url)!, webViewStateModel: self.webViewStateModel)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(
            Text(webViewStateModel.pageTitle)
            , displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack(spacing: 16) {
                    Button {
                        if self.webViewStateModel.canGoBack {
                            self.webViewStateModel.goBack.toggle()
                        }
                    } label: {
                        goBackImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    
                    Button {
                        if self.webViewStateModel.canGoForward {
                            self.webViewStateModel.goForward.toggle()
                        }
                    } label: {
                        goForwardImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    
                    Spacer()
                }
                .accentColor(tintColor)
            }
        }
        .navigationBarItems(
            leading:
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    backText
                }
                .accentColor(tintColor)
            , trailing:
                Button {
                    self.webViewStateModel.reload.toggle()
                } label: {
                    reloadImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .accentColor(tintColor)
        )
        
    }
}
