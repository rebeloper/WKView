# 🕸 WKView

**WKView** is a lightweight library to present web content in your SwiftUI app with the help of `WebKit`.

## 💻 Installation
### 📦 Swift Package Manager
Using <a href="https://swift.org/package-manager/" rel="nofollow">Swift Package Manager</a>, add it as a Swift Package in Xcode 11.0 or later, `select File > Swift Packages > Add Package Dependency...` and add the repository URL:
```
https://github.com/rebeloper/WKView.git
```
### ✊ Manual Installation
Download and include the `WKView` folder and files in your codebase.

### 📲 Requirements
- iOS 14+
- Swift 5

## 🎬 Video Tutorial

<p><a href="https://www.youtube.com/watch?v=FPvH3--Q3ys&list=PL_csAAO9PQ8Yj7ZU7n2IJjIsqcFaLcvJN&index=3">WKWebView SwiftUI on YouTube</a></p>

## 👉 Import

Import `WKView` into your `View`

```
import WKView
```

## 🛠 How to use

The simplest way to use `WKView` is to call `WebView` with a `URL String`. 
IMPORTANT: `WebView` must be presented inside a `NavigationView`.

```
import SwiftUI
import WKView

struct ContentView: View {
    var body: some View {
        NavigationView {
            WebView(url: "https://rebeloper.com", hidesBackButton: true)
        }
    }
}
```

Note: Here we are hiding the **Back button** of the web view by setting `hidesBackButton` to `false` because the `ContentView` is the root view of our app.

## 🧳 Features

In the example below you can see one pushed and two presented `WebView`s. Take a look at the cool ways you may customize the `WebView` style.

```
import SwiftUI
import WKView

struct ContentView: View {
    
    @State var isSheetPresented = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Divider()
                
                // 1. Push a WebView with a url
                NavigationLink("Push WebView", destination: WebView(url: "https://rebeloper.com"))
                
                Button(action: {
                    isSheetPresented.toggle()
                }, label: {
                    Text("Present WebView")
                }).sheet(isPresented: $isSheetPresented, content: {
                    NavigationView {
                        // 2. Present WebView in a modal with hiding the back button
//                        WebView(url: "https://rebeloper.com", hidesBackButton: true)
                        
                        // 3. Present a customized WebView in a modal
//                        WebView(url: "https://rebeloper.com",
//                                tintColor: .red,
//                                titleColor: .yellow,
//                                backText: Text("Cancel").italic(),
//                                reloadImage: Image(system"figure.wave"),
//                                goForwardImage: Image(system"forward.frame.fill"),
//                                goBackImage: Image(system"backward.frame.fill"))

                        // 4. Present WebView in a modal with a constant title
//                        WebView(url: "https://rebeloper.com", title: "WKView")
                        
                        // 5. Present a webview with onNavigationAction and optional: allowedHosts, forbiddenHosts and credential
                        WebView(url: "https://rebeloper.com"//,
//                                allowedHosts: ["github", ".com"],
//                                forbiddenHosts: [".org", "google"],
//                                credential: URLCredential(user: "user", password: "password", persistence: .none)
                        ){ (onNavigationAction) in
                            switch onNavigationAction {
                            case .decidePolicy(let webView, let navigationAction, let policy):
                                print("WebView -> \(String(describing: webView.url)) -> decidePolicy navigationAction: \(navigationAction)")
                                switch policy {
                                case .cancel:
                                    print("WebView -> \(String(describing: webView.url)) -> decidePolicy: .cancel")
                                    isSheetPresented = false
                                case .allow:
                                    print("WebView -> \(String(describing: webView.url)) -> decidePolicy: .allow")
                                @unknown default:
                                    print("WebView -> \(String(describing: webView.url)) -> decidePolicy: @unknown default")
                                }
                                
                            case .didRecieveAuthChallenge(let webView, let challenge, let disposition, let credential):
                                print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange challenge: \(challenge.protectionSpace.host)")
                                print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange disposition: \(disposition.rawValue)")
                                if let credential = credential {
                                    print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange credential: \(credential)")
                                }
                                
                            case .didStartProvisionalNavigation(let webView, let navigation):
                                print("WebView -> \(String(describing: webView.url)) -> didStartProvisionalNavigation: \(navigation)")
                            case .didReceiveServerRedirectForProvisionalNavigation(let webView, let navigation):
                                print("WebView -> \(String(describing: webView.url)) -> didReceiveServerRedirectForProvisionalNavigation: \(navigation)")
                            case .didCommit(let webView, let navigation):
                                print("WebView -> \(String(describing: webView.url)) -> didCommit: \(navigation)")
                            case .didFinish(let webView, let navigation):
                                print("WebView -> \(String(describing: webView.url)) -> didFinish: \(navigation)")
                            case .didFailProvisionalNavigation(let webView, let navigation, let error):
                                print("WebView -> \(String(describing: webView.url)) -> didFailProvisionalNavigation: \(navigation)")
                                print("WebView -> \(String(describing: webView.url)) -> didFailProvisionalNavigation: \(error)")
                            case .didFail(let webView, let navigation, let error):
                                print("WebView -> \(String(describing: webView.url)) -> didFail: \(navigation)")
                                print("WebView -> \(String(describing: webView.url)) -> didFail: \(error)")
                            }
                        }
                        
                    }
                })
                Spacer()
            }
            .navigationBarTitle("WKView")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}
```
## 📱 Screenshots

<details>
    <summary>Pushed WebView</summary>
    <img src="../media/Sources/ReadMeAssets/WKView00000.png" width="350px">
</details>

<details>
    <summary>Presented WebView</summary>
    <img src="../media/Sources/ReadMeAssets/WKView00001.png" width="350px">
</details>

<details>
    <summary>Custom Presented WebView</summary>
    <img src="../media/Sources/ReadMeAssets/WKView00002.png" width="350px">
</details>

## ✍️ Contact

<a href="https://rebeloper.com/">rebeloper.com</a> / 
<a href="https://www.youtube.com/rebeloper/">YouTube</a> / 
<a href="https://store.rebeloper.com/">Shop</a> / 
<a href="https://rebeloper.com/mentoring">Mentoring</a>

## 📃 License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
