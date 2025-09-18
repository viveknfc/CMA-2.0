//
//  WebView_Support.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 24/07/25.
//

//import SwiftUI
//import WebKit

//struct WebView: UIViewRepresentable {
//    let url: URL
//    @Binding var isLoading: Bool
//    let division: DivisionList
//    let payload: WebViewPayload
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.navigationDelegate = context.coordinator
//        
//        // Inject JavaScript as user script to ensure it runs on every page load
//        let userScript = WKUserScript(
//            source: context.coordinator.getJavaScriptCode(),
//            injectionTime: .atDocumentEnd,
//            forMainFrameOnly: false
//        )
//        webView.configuration.userContentController.addUserScript(userScript)
//        
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        if uiView.url != url {
//            let request = URLRequest(
//                url: url,
//                cachePolicy: .reloadIgnoringLocalCacheData,
//                timeoutInterval: 30
//            )
//            uiView.load(request)
//        }
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: WebView
//        
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//        
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            parent.isLoading = true
//        }
//        
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            parent.isLoading = false
//            print("❌ Navigation failed: \(error.localizedDescription)")
//        }
//        
//        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//            parent.isLoading = false
//            print("❌ Provisional navigation failed: \(error.localizedDescription)")
//        }
//        
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.isLoading = false
//            print("✅ Navigation finished for URL: \(webView.url?.absoluteString ?? "unknown")")
//            
//            // Inject JavaScript immediately without delay
//            injectJavaScript(into: webView)
//        }
//        
//        // Handle redirects and new navigations
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            print("🔄 Navigation to: \(navigationAction.request.url?.absoluteString ?? "unknown")")
//            decisionHandler(.allow)
//        }
//        
//        // This will be called for each new page load including redirects
//        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//            print("📄 Page committed: \(webView.url?.absoluteString ?? "unknown")")
//            // Inject JavaScript as soon as the page commits
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.injectJavaScript(into: webView)
//            }
//        }
//
//        func getJavaScriptCode() -> String {
//            func escapeForJS(_ json: String) -> String {
//                let trimmed = json.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
//                return trimmed
//                    .replacingOccurrences(of: "\\", with: "\\\\")
//                    .replacingOccurrences(of: "\"", with: "\\\"")
//                    .replacingOccurrences(of: "\n", with: "\\n")
//                    .replacingOccurrences(of: "\r", with: "\\r")
//            }
//            
//            let escapedCwaDetails = escapeForJS(makeEscapedCwaDetailsString(from: parent.division))
//            let escapedCurrentUser = escapeForJS(parent.payload.currentUserJson)
//            let escapedKeyGuard = escapeForJS(parent.payload.keyGuard)
//            let escapedKeyName = escapeForJS(parent.payload.keyName)
//            
//            return """
//            (function() {
//                try {
//                    console.log('🚀 Injecting data...');
//                    
//                    const cwaDetails = JSON.parse("\(escapedCwaDetails)");
//                    sessionStorage.setItem("cwaDetails", JSON.stringify(cwaDetails));
//                    console.log('✅ cwaDetails set');
//                    
//                    const currentUser = JSON.parse("\(escapedCurrentUser)");
//                    localStorage.setItem("currentUser", JSON.stringify(currentUser));
//                    console.log('✅ currentUser set');
//                    
//                    localStorage.setItem("keygaurd", "\(escapedKeyGuard)");
//                    localStorage.setItem("keyname", "\(escapedKeyName)");
//                    localStorage.setItem("isHeadless", "true");
//                    console.log('✅ All data injected successfully');
//                    
//                } catch (error) {
//                    console.error('❌ JavaScript injection error:', error);
//                }
//            })();
//            """
//        }
//
//        private func injectJavaScript(into webView: WKWebView) {
//            let js = getJavaScriptCode()
//            
//            webView.evaluateJavaScript(js) { result, error in
//                if let error = error {
//                    print("❌ JavaScript injection failed: \(error)")
//                } else {
//                    print("✅ JavaScript injected successfully for URL: \(webView.url?.absoluteString ?? "unknown")")
//                }
//            }
//        }
//    }
//}
//
//
//import SwiftUI
//import WebKit
//
//struct WebView: UIViewRepresentable {
//    let url: URL
//    @Binding var isLoading: Bool
//    
//    let candidateData: String
//    let candidateInfo: String
//    let currentUserJson: String
//    let keyGuard: String
//    let keyName: String
//    let accessToken: String
//    let isHeadless: Bool
//    var onTitleChange: ((String) -> Void)?
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
////        let preferences = WKWebpagePreferences()
////        preferences.allowsContentJavaScript = true
////
////        let config = WKWebViewConfiguration()
////        config.defaultWebpagePreferences = preferences
////        config.websiteDataStore = .default()
//        let config = WKWebViewConfiguration()
//        let preferences = WKPreferences()
//        preferences.javaScriptEnabled = true
//        config.preferences = preferences
//        config.defaultWebpagePreferences.allowsContentJavaScript = true
//        config.websiteDataStore = .default()
//       
//
//        
//        // Inject JavaScript as early as possible using user script
//        let userScript = WKUserScript(
//            source: context.coordinator.createJavaScript(),
//            injectionTime: .atDocumentStart,
//            forMainFrameOnly: false
//        )
//        config.userContentController.addUserScript(userScript)
//        
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.navigationDelegate = context.coordinator
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        if uiView.url != url {
//            print("✅ WebView is loading: \(url.absoluteString)")
//            let request = URLRequest(
//                url: url,
//                cachePolicy: .reloadIgnoringLocalCacheData,
//                timeoutInterval: 30
//            )
//            uiView.load(request)
//        }
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: WebView
//        private var hasInjectedForCurrentPage = false
//        private var currentPageURL: String = ""
//
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            parent.isLoading = true
//            hasInjectedForCurrentPage = false
//            print("🚀 Started loading: \(webView.url?.absoluteString ?? "unknown")")
//        }
//
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            parent.isLoading = false
//            hasInjectedForCurrentPage = false
//            print("❌ Navigation failed: \(error.localizedDescription)")
//        }
//
//        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//            parent.isLoading = false
//            hasInjectedForCurrentPage = false
//            print("❌ Provisional navigation failed: \(error.localizedDescription)")
//        }
//        
//        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//            let newURL = webView.url?.absoluteString ?? ""
//            if newURL != currentPageURL {
//                currentPageURL = newURL
//                hasInjectedForCurrentPage = false
//                print("📄 Page committed: \(newURL)")
//                
//                // Inject as soon as DOM is available
//                injectJavaScriptIfNeeded(into: webView)
//            }
//        }
//        
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.isLoading = false
//            parent.onTitleChange?(webView.title ?? "Untitled")
//            print("✅ Page finished loading: \(webView.url?.absoluteString ?? "unknown")")
//            
//            // Final fallback injection
//            injectJavaScriptIfNeeded(into: webView)
//        }
//        
//        func createJavaScript() -> String {
//            func jsSafe(_ string: String) -> String {
//                return string
//                    .replacingOccurrences(of: "\\", with: "\\\\")
//                    .replacingOccurrences(of: "'", with: "\\'")
//                    .replacingOccurrences(of: "\n", with: "\\n")
//                    .replacingOccurrences(of: "\r", with: "\\r")
//                    .replacingOccurrences(of: "\t", with: "\\t")
//            }
//
//            let candidateDataStr = parent.candidateData.isEmpty ? "{}" : jsSafe(parent.candidateData)
//            
//            return """
//            (function fillFieldsReact() {
//                var data = JSON.parse('\(candidateDataStr)');
//                var maxRetries = 50;
//                var interval = 100;
//
//                function setReactValue(el, value) {
//                    el.focus();
//                    var lastValue = el.value;
//                    el.value = value;
//                    var event = new Event('input', { bubbles: true });
//                    var tracker = el._valueTracker;
//                    if(tracker) { tracker.setValue(lastValue); }
//                    el.dispatchEvent(event);
//                    el.dispatchEvent(new Event('change', { bubbles: true }));
//                    el.blur();
//                }
//
//                function tryFill(retriesLeft) {
//                    var allFound = true;
//                    for(var key in data) {
//                        var el = document.querySelector('[name="'+key+'"], [id="'+key+'"]');
//                        if(el) {
//                            setReactValue(el, data[key]);
//                        } else {
//                            allFound = false;
//                        }
//                    }
//
//                    if(!allFound && retriesLeft > 0) {
//                        setTimeout(function(){ tryFill(retriesLeft-1); }, interval);
//                    } else if(allFound) {
//                        window.webkit.messageHandlers.iosInjectHandler.postMessage('inject_success');
//                    } else {
//                        window.webkit.messageHandlers.iosInjectHandler.postMessage('inject_failed');
//                    }
//                }
//
//                tryFill(maxRetries);
//            })();
//            """
//        }
//
//
//        
//        private func injectJavaScriptIfNeeded(into webView: WKWebView) {
//            guard !hasInjectedForCurrentPage else {
//                print("📝 JavaScript already injected for current page, skipping...")
//                return
//            }
//            
//            // Debug data before injection
//            validateDataBeforeInjection()
//            
//            hasInjectedForCurrentPage = true
//            let js = createJavaScript()
//            
//            webView.evaluateJavaScript(js) { result, error in
//                if let error = error {
//                    print("❌ JS injection error: \(error.localizedDescription)")
//                    // Reset flag to allow retry
//                    self.hasInjectedForCurrentPage = false
//                } else {
//                    print("✅ JavaScript injected successfully for: \(webView.url?.absoluteString ?? "unknown")")
//                }
//            }
//        }
//        
//        private func validateDataBeforeInjection() {
//            print("🔍 Data validation before injection:")
//            print("  candidateData: \(parent.candidateData.isEmpty ? "EMPTY" : "✓ \(parent.candidateData.count) chars")")
//            print("  candidateInfo: \(parent.candidateInfo.isEmpty ? "EMPTY" : "✓ \(parent.candidateInfo.count) chars")")
//            print("  currentUserJson: \(parent.currentUserJson.isEmpty ? "EMPTY" : "✓ \(parent.currentUserJson.count) chars")")
//            print("  keyGuard: \(parent.keyGuard.isEmpty ? "EMPTY" : "✓")")
//            print("  keyName: \(parent.keyName.isEmpty ? "EMPTY" : "✓")")
//            print("  accessToken: \(parent.accessToken.isEmpty ? "EMPTY" : "✓")")
//        }
//        
//        private func escapeForJavaScript(_ string: String) -> String {
//            return string
//                .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
//                .replacingOccurrences(of: "\\", with: "\\\\")
//                .replacingOccurrences(of: "\"", with: "\\\"")
//                .replacingOccurrences(of: "\n", with: "\\n")
//                .replacingOccurrences(of: "\r", with: "\\r")
//                .replacingOccurrences(of: "\t", with: "\\t")
//            }
//    }
//}
//
//
import SwiftUI
import WebKit

//struct WebViewScreen: UIViewRepresentable {
//    let url: URL
//    @Binding var isLoading: Bool
//    let payloadJSON: String   // Clean JSON string
//    
//    func makeCoordinator() -> Coordinator { Coordinator(self) }
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let prefs = WKWebpagePreferences()
//        prefs.allowsContentJavaScript = true
//        
//        let config = WKWebViewConfiguration()
//        config.defaultWebpagePreferences = prefs
//        config.preferences.javaScriptCanOpenWindowsAutomatically = true
//        config.websiteDataStore = .default()
//        
//        // Add message handlers
//        config.userContentController.add(context.coordinator, name: "iosInjectHandler")
//        config.userContentController.add(context.coordinator, name: "printPage")
//        
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.navigationDelegate = context.coordinator
//        webView.uiDelegate = context.coordinator
//        webView.allowsBackForwardNavigationGestures = true
//        
//        webView.load(URLRequest(url: url))
//        return webView
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {}
//    
//    // MARK: - Coordinator
//    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIDocumentPickerDelegate {
//        let parent: WebViewScreen
//        init(_ parent: WebViewScreen) { self.parent = parent }
//        
//        private func payloadBase64() -> String? {
//            parent.payloadJSON
//                .data(using: .utf8)?
//                .base64EncodedString()
//                .replacingOccurrences(of: "\n", with: "")
//        }
//        
//        // Inject after page fully loaded
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//          //  guard let b64 = payloadBase64() else { return }
////            let cleaned = parent.payloadJSON
////                .replacingOccurrences(of: "\\\"", with: "\"")   // unescape inner quotes
////                .trimmingCharacters(in: CharacterSet(charactersIn: "\"")) // remove leading/trailing "
////
////            print(cleaned)  // Now it’s valid JSON
////            let b64 = cleaned.data(using: .utf8)!.base64EncodedString()
////            let js = """
////            (function waitForPage() {
////                if (document.readyState !== 'complete') {
////                    setTimeout(waitForPage, 50);
////                    return;
////                }
////                try {
////                    var json = JSON.parse(decodeURIComponent(escape(atob('\(b64)'))));
////                    localStorage.setItem('currentUser', JSON.stringify(json));
////                    sessionStorage.setItem('cwaDetails', JSON.stringify(json));
////                    localStorage.setItem('isHeadless', 'true');
////                    window.webkit.messageHandlers.iosInjectHandler.postMessage('inject_success');
////                } catch(e) {
////                    window.webkit.messageHandlers.iosInjectHandler.postMessage('parse_error: ' + e.message);
////                }
////            })();
////            """
////            
////            webView.evaluateJavaScript(js) { _, error in
////                if let error = error {
////                    print("evaluateJavascript error: \(error)")
////                }
////            }
////            
////            // Override print
////            let printJS = """
////            (function() { window.print = function(){ window.webkit.messageHandlers.printPage.postMessage('print'); }; })();
////            """
////            webView.evaluateJavaScript(printJS, completionHandler: nil)
//            let cleaned = parent.payloadJSON
//                .replacingOccurrences(of: "\\\"", with: "\"")   // unescape inner quotes
//                .trimmingCharacters(in: CharacterSet(charactersIn: "\"")) // remove leading/trailing "
//
//            print("CLEAN JSON:", cleaned)
//
//            if let data = cleaned.data(using: .utf8) {
//                let b64 = data.base64EncodedString()
//                
//                let js = """
//                (function waitForPage() {
//                    if (document.readyState !== 'complete') {
//                        setTimeout(waitForPage, 50);
//                        return;
//                    }
//                    try {
//                        var decoded = atob('\(b64)');
//                        var json = JSON.parse(decoded);
//                        localStorage.setItem('currentUser', JSON.stringify(json));
//                        sessionStorage.setItem('cwaDetails', JSON.stringify(json));
//                        localStorage.setItem('isHeadless', 'true');
//                        window.webkit.messageHandlers.iosInjectHandler.postMessage('inject_success');
//                    } catch(e) {
//                        window.webkit.messageHandlers.iosInjectHandler.postMessage('parse_error: ' + e.message);
//                    }
//                })();
//                """
//                
//                webView.evaluateJavaScript(js) { _, error in
//                    if let error = error {
//                        print("evaluateJavascript error: \(error)")
//                    }
//                }
//            }
//
//        }
//        
//        // JS → Native messages
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            if message.name == "iosInjectHandler" {
//                if let str = message.body as? String {
//                    print("JS Inject message:", str)
//                    if str == "inject_success" {
//                        DispatchQueue.main.async {
//                            self.parent.isLoading = false
//                        }
//                    }
//                }
//            } else if message.name == "printPage" {
//                print("JS requested print")
//                // Implement native print if needed
//            }
//        }
//        
//        // MARK: - File picker (iOS 18+)
//        #if compiler(>=6.0)
//        @available(iOS 18.4, *)
//        func webView(_ webView: WKWebView,
//                     runOpenPanelWith parameters: WKOpenPanelParameters,
//                     initiatedByFrame frame: WKFrameInfo,
//                     completionHandler: @escaping ([URL]?) -> Void) {
//            
//            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
//            picker.delegate = self
//            picker.modalPresentationStyle = .formSheet
//            
//            self.filePickerCompletion = completionHandler
//            UIApplication.shared.connectedScenes
//                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
//                .first?.rootViewController?
//                .present(picker, animated: true)
//        }
//        #endif
//        
//        private var filePickerCompletion: (([URL]?) -> Void)?
//        
//        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            filePickerCompletion?(urls)
//            filePickerCompletion = nil
//        }
//        
//        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//            filePickerCompletion?(nil)
//            filePickerCompletion = nil
//        }
//    }
//}

import SwiftUI
import WebKit

struct WebViewScreen: UIViewRepresentable {
    let url: URL
    let payload: [String: Any]
    @Binding var isLoading: Bool
    var onTitleChange: ((String) -> Void)? = nil

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        config.userContentController.add(context.coordinator, name: "iosInjectHandler")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        private let parent: WebViewScreen

        init(_ parent: WebViewScreen) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async { self.parent.isLoading = true }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async { self.parent.isLoading = false }
            parent.onTitleChange?(webView.title ?? "")
            injectFormData(webView)
        }

        private func injectFormData(_ webView: WKWebView) {
            guard JSONSerialization.isValidJSONObject(parent.payload) else {
                print("❌ Payload is not valid JSON")
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parent.payload, options: [])
                let base64 = jsonData.base64EncodedString()

                let js = """
                (function() {
                  function b64DecodeUnicode(str) {
                    try {
                      var binary = atob(str);
                      var bytes = [];
                      for (var i = 0; i < binary.length; i++) {
                        bytes.push('%' + ('00' + binary.charCodeAt(i).toString(16)).slice(-2));
                      }
                      return decodeURIComponent(bytes.join(''));
                    } catch (e) {
                      return atob(str);
                    }
                  }

                  try {
                    var raw = b64DecodeUnicode('\(base64)');
                    var data = JSON.parse(raw);

                    var inputs = Array.from(document.querySelectorAll("input[type='text'], input[type='email'], input[type='tel'], textarea"));

                    function setVal(idx, val) {
                      if (!val && val !== 0) return;
                      var el = inputs[idx];
                      if (!el) return;
                      el.value = String(val);
                      el.dispatchEvent(new Event('input', { bubbles: true }));
                      el.dispatchEvent(new Event('change', { bubbles: true }));
                    }

                    // Index mapping from screenshot:
                    // 0: Company Name
                    // 1: Contact Name
                    // 2: Contact Email
                    // 3: Address
                    // 4: Suite
                    // 5: City
                    // 6: State
                    // 7: Zip
                    // 8: Phone
                    // 9: Ext
                    // 10: Fax

                    setVal(0, data.CompanyName || data.CompName);
                    setVal(1, data.Name);
                    setVal(2, data.AddETo || data.RepEmail);
                    setVal(3, data.CompanyAddress || data.ContactAddress);
                    setVal(4, data.Suite);
                    setVal(5, data.City);
                    setVal(6, data.State || data.CompanyState);
                    setVal(7, data.CodeZip || data.CompanyCodeZip);
                    setVal(8, data.Phone || data.MainTelPhone);
                    setVal(9, data.Ext);
                    setVal(10, data.Fax);

                    window.webkit.messageHandlers.iosInjectHandler.postMessage({ type: 'success', message: 'Form fields filled', keys: Object.keys(data) });
                  } catch (err) {
                    window.webkit.messageHandlers.iosInjectHandler.postMessage({ type: 'inject_error', message: err.message });
                  }
                })();
                """

                webView.evaluateJavaScript(js) { (_, error) in
                    if let err = error {
                        print("❌ JS injection error: \(err.localizedDescription)")
                    } else {
                        print("✅ JS evaluated")
                    }
                }

            } catch {
                print("❌ JSON serialization failed:", error.localizedDescription)
            }
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "iosInjectHandler" else { return }
            if let body = message.body as? [String: Any],
               let type = body["type"] as? String {
                print("📩 JS -> iOS (\(type)): \(body)")
            }
        }
    }
}
