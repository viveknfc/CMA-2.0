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
        
        // Inject JavaScript as user script to ensure it runs on every page load
        let userScript = WKUserScript(
            source: context.coordinator.getJavaScriptCode(),
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
        webView.configuration.userContentController.addUserScript(userScript)
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            let request = URLRequest(
                url: url,
                cachePolicy: .reloadIgnoringLocalCacheData,
                timeoutInterval: 30
            )
            uiView.load(request)
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
            print("❌ Navigation failed: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            print("❌ Provisional navigation failed: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            print("✅ Navigation finished for URL: \(webView.url?.absoluteString ?? "unknown")")
            
            // Inject JavaScript immediately without delay
            injectJavaScript(into: webView)
        }
        
        // Handle redirects and new navigations
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            print("🔄 Navigation to: \(navigationAction.request.url?.absoluteString ?? "unknown")")
            decisionHandler(.allow)
        }
        
        // This will be called for each new page load including redirects
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("📄 Page committed: \(webView.url?.absoluteString ?? "unknown")")
            // Inject JavaScript as soon as the page commits
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.injectJavaScript(into: webView)
            }
        }

        func getJavaScriptCode() -> String {
            func escapeForJS(_ json: String) -> String {
                let trimmed = json.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                return trimmed
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "\n", with: "\\n")
                    .replacingOccurrences(of: "\r", with: "\\r")
            }
            
            let escapedCwaDetails = escapeForJS(makeEscapedCwaDetailsString(from: parent.division))
            let escapedCurrentUser = escapeForJS(parent.payload.currentUserJson)
            let escapedKeyGuard = escapeForJS(parent.payload.keyGuard)
            let escapedKeyName = escapeForJS(parent.payload.keyName)
            
            return """
            (function() {
                try {
                    console.log('🚀 Injecting data...');
                    
                    const cwaDetails = JSON.parse("\(escapedCwaDetails)");
                    sessionStorage.setItem("cwaDetails", JSON.stringify(cwaDetails));
                    console.log('✅ cwaDetails set');
                    
                    const currentUser = JSON.parse("\(escapedCurrentUser)");
                    localStorage.setItem("currentUser", JSON.stringify(currentUser));
                    console.log('✅ currentUser set');
                    
                    localStorage.setItem("keygaurd", "\(escapedKeyGuard)");
                    localStorage.setItem("keyname", "\(escapedKeyName)");
                    localStorage.setItem("isHeadless", "true");
                    console.log('✅ All data injected successfully');
                    
                } catch (error) {
                    console.error('❌ JavaScript injection error:', error);
                }
            })();
            """
        }

        private func injectJavaScript(into webView: WKWebView) {
            let js = getJavaScriptCode()
            
            webView.evaluateJavaScript(js) { result, error in
                if let error = error {
                    print("❌ JavaScript injection failed: \(error)")
                } else {
                    print("✅ JavaScript injected successfully for URL: \(webView.url?.absoluteString ?? "unknown")")
                }
            }
        }
    }
}


