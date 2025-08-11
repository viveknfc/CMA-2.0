//
//  WebView_Support.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 24/07/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    let division: DivisionList
    let payload: WebViewPayload

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            
            func escapeForJS(_ json: String) -> String {
                let trimmed = json.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                return trimmed
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
            }
            
            let escapedCwaDetails = escapeForJS(makeEscapedCwaDetailsString(from: parent.division))
            let escapedCurrentUser = escapeForJS(parent.payload.currentUserJson)
            let escapedKeyGuard = escapeForJS(parent.payload.keyGuard)
            let escapedKeyName = escapeForJS(parent.payload.keyName)
            
            let js = """
            const cwaDetails = JSON.parse("\(escapedCwaDetails)");
            localStorage.setItem("cwaDetails", JSON.stringify(cwaDetails));
            
            const currentUser = JSON.parse("\(escapedCurrentUser)");
            localStorage.setItem("currentUser", JSON.stringify(currentUser));
            
            localStorage.setItem("keygaurd", "\(escapedKeyGuard)");
            localStorage.setItem("keyname", "\(escapedKeyName)");
            localStorage.setItem("isHeadless", "true");
            """
            
            webView.evaluateJavaScript(js) { result, error in
                if let error = error {
                    print("❌ JavaScript injection failed: \(error)")
                } else {
                    print("✅ JavaScript injected successfully.")
                }
            }
        }
    }
}

