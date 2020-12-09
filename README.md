# 🕸 WKView

**WKView** is a lightweight library to present web content in your SwiftUI app with the help of `WebKit`.

## 💻 Installation
### 📦 Swift Package Manager
Using <a href="https://swift.org/package-manager/" rel="nofollow">Swift Package Manager</a>, add it as a Swift Package in Xcode 11.0 or later, `select File > Swift Packages > Add Package Dependency...` and add the repository URL:
```
https://github.com/rebeloper/WKView.git
```
### ✊ Manual Installation
Download and include the `Stax` folder and files in your codebase.

### 📲 Requirements
- iOS 14+
- Swift 5

## 👉 Import

Import `WKView` into your `ViewController`

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

## Features

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
                        WebView(url: "https://rebeloper.com",
                                tintColor: .red,
                                titleColor: .yellow,
                                backText: Text("Cancel").italic(),
                                hidesBackButton: false,
                                reloadImage: Image(systemName: "figure.wave"),
                                goForwardImage: Image(systemName: "forward.frame.fill"),
                                goBackImage: Image(systemName: "backward.frame.fill"))
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

## ✍️ Contact

<a href="http://rebeloper.com/">rebeloper.com</a> / 
<a href="http://www.youtube.com/rebeloper/">YouTube</a> / 
<a href="http://store.rebeloper.com/">Shop</a> / 
<a href="http://rebeloper.com/mentoring">Mentoring</a>

## 📃 License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
