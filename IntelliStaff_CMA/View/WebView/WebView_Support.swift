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
//import SwiftUI
//import WebKit

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

//import SwiftUI
//import WebKit

//struct WebViewScreen: UIViewRepresentable {
//    let url: URL
//    let payload: [String: Any]
//    @Binding var isLoading: Bool
//    var onTitleChange: ((String) -> Void)? = nil
//
//    func makeCoordinator() -> Coordinator { Coordinator(self) }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let prefs = WKWebpagePreferences()
//        prefs.allowsContentJavaScript = true
//
//        let config = WKWebViewConfiguration()
//        config.defaultWebpagePreferences = prefs
//        config.userContentController.add(context.coordinator, name: "iosInjectHandler")
//
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.navigationDelegate = context.coordinator
//        webView.load(URLRequest(url: url))
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) { }
//
//    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
//        private let parent: WebViewScreen
//
//        init(_ parent: WebViewScreen) {
//            self.parent = parent
//        }
//
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            DispatchQueue.main.async { self.parent.isLoading = true }
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            DispatchQueue.main.async { self.parent.isLoading = false }
//            parent.onTitleChange?(webView.title ?? "")
//            injectFormData(webView)
//        }
//
//        private func injectFormData(_ webView: WKWebView) {
//            guard JSONSerialization.isValidJSONObject(parent.payload) else {
//                print("❌ Payload is not valid JSON")
//                return
//            }
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: parent.payload, options: [])
//                let base64 = jsonData.base64EncodedString()
//
//                let js = """
//                (function() {
//                  function b64DecodeUnicode(str) {
//                    try {
//                      var binary = atob(str);
//                      var bytes = [];
//                      for (var i = 0; i < binary.length; i++) {
//                        bytes.push('%' + ('00' + binary.charCodeAt(i).toString(16)).slice(-2));
//                      }
//                      return decodeURIComponent(bytes.join(''));
//                    } catch (e) {
//                      return atob(str);
//                    }
//                  }
//
//                  try {
//                    var raw = b64DecodeUnicode('\(base64)');
//                    var data = JSON.parse(raw);
//
//                    var inputs = Array.from(document.querySelectorAll("input[type='text'], input[type='email'], input[type='tel'], textarea"));
//
//                    function setVal(idx, val) {
//                      if (!val && val !== 0) return;
//                      var el = inputs[idx];
//                      if (!el) return;
//                      el.value = String(val);
//                      el.dispatchEvent(new Event('input', { bubbles: true }));
//                      el.dispatchEvent(new Event('change', { bubbles: true }));
//                    }
//
//                    // Index mapping from screenshot:
//                    // 0: Company Name
//                    // 1: Contact Name
//                    // 2: Contact Email
//                    // 3: Address
//                    // 4: Suite
//                    // 5: City
//                    // 6: State
//                    // 7: Zip
//                    // 8: Phone
//                    // 9: Ext
//                    // 10: Fax
//
//                    setVal(0, data.CompanyName || data.CompName);
//                    setVal(1, data.Name);
//                    setVal(2, data.AddETo || data.RepEmail);
//                    setVal(3, data.CompanyAddress || data.ContactAddress);
//                    setVal(4, data.Suite);
//                    setVal(5, data.City);
//                    setVal(6, data.State || data.CompanyState);
//                    setVal(7, data.CodeZip || data.CompanyCodeZip);
//                    setVal(8, data.Phone || data.MainTelPhone);
//                    setVal(9, data.Ext);
//                    setVal(10, data.Fax);
//
//                    window.webkit.messageHandlers.iosInjectHandler.postMessage({ type: 'success', message: 'Form fields filled', keys: Object.keys(data) });
//                  } catch (err) {
//                    window.webkit.messageHandlers.iosInjectHandler.postMessage({ type: 'inject_error', message: err.message });
//                  }
//                })();
//                """
//
//                webView.evaluateJavaScript(js) { (_, error) in
//                    if let err = error {
//                        print("❌ JS injection error: \(err.localizedDescription)")
//                    } else {
//                        print("✅ JS evaluated")
//                    }
//                }
//
//            } catch {
//                print("❌ JSON serialization failed:", error.localizedDescription)
//            }
//        }
//
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            guard message.name == "iosInjectHandler" else { return }
//            if let body = message.body as? [String: Any],
//               let type = body["type"] as? String {
//                print("📩 JS -> iOS (\(type)): \(body)")
//            }
//        }
//    }
//}
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
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let preferences = WKWebpagePreferences()
//        preferences.allowsContentJavaScript = true
//
//        let config = WKWebViewConfiguration()
//        config.defaultWebpagePreferences = preferences
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
//        
//        // 🔹 Enable pinch-to-zoom
//             webView.scrollView.minimumZoomScale = 1.0
//             webView.scrollView.maximumZoomScale = 4.0
//             webView.scrollView.zoomScale = 1.0
//             webView.scrollView.bouncesZoom = true
//             
//             // 🔹 Prevent content scaling override
//             webView.configuration.preferences.javaScriptEnabled = true
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
//            // Pre-process all data once and handle empty values
//            let processedCandidateData = parent.candidateData.isEmpty ? "{}" : escapeForJavaScript(parent.candidateData)
//            let processedCurrentUserJson = parent.currentUserJson.isEmpty ? "{}" : escapeForJavaScript(parent.currentUserJson)
//            let processedCandidateInfo = parent.candidateInfo.isEmpty ? "{}" : escapeForJavaScript(parent.candidateInfo)
//            let processedKeyGuard = escapeForJavaScript(parent.keyGuard)
//            let processedKeyName = escapeForJavaScript(parent.keyName)
//            let processedAccessToken = escapeForJavaScript(parent.accessToken)
//            let isHeadlessStr = parent.isHeadless ? "true" : "false"
//            
//            return """
//            (function() {
//                // Prevent duplicate injections
//                if (window.candidateDataInjected) {
//                    console.log('📝 Candidate data already injected, skipping...');
//                    return;
//                }
//                
//                function injectCandidateData() {
//                    try {
//                        console.log('🚀 Starting candidate data injection...');
//                        
//                        // Parse and store candidate data (handle empty case)
//                        const candidateDataStr = "\(processedCandidateData)";
//                        if (candidateDataStr && candidateDataStr.trim() !== "") {
//                            const candidateData = JSON.parse(candidateDataStr);
//                            localStorage.setItem("candidateData", JSON.stringify(candidateData));
//                            console.log('✅ candidateData stored');
//                        } else {
//                            console.log('⚠️ candidateData is empty, skipping...');
//                        }
//                        
//                        // Parse and store current user data
//                        const currentUserStr = "\(processedCurrentUserJson)";
//                        if (currentUserStr && currentUserStr.trim() !== "") {
//                            const currentUserData = JSON.parse(currentUserStr);
//                            localStorage.setItem("currentUserEWA", JSON.stringify(currentUserData));
//                            console.log('✅ currentUserEWA stored');
//                            
//                            // Use accessToken from currentUser if available
//                            if (currentUserData.accessToken) {
//                                localStorage.setItem("accessToken", currentUserData.accessToken);
//                            } else {
//                                localStorage.setItem("accessToken", "\(processedAccessToken)");
//                            }
//                        } else {
//                            // Fallback to provided accessToken
//                            localStorage.setItem("accessToken", "\(processedAccessToken)");
//                            console.log('⚠️ currentUserData is empty, using fallback accessToken');
//                        }
//                        
//                        // Parse and store candidate info (handle empty case)
//                        const candidateInfoStr = "\(processedCandidateInfo)";
//                        if (candidateInfoStr && candidateInfoStr.trim() !== "") {
//                            const candidateInfo = JSON.parse(candidateInfoStr);
//                            sessionStorage.setItem("loggedinInfo", JSON.stringify(candidateInfo));
//                            console.log('✅ loggedinInfo stored');
//                        } else {
//                            console.log('⚠️ candidateInfo is empty, skipping...');
//                        }
//                        
//                        // Store additional data (these should always be available)
//                        localStorage.setItem("keygaurd", "\(processedKeyGuard)");
//                        localStorage.setItem("keyname", "\(processedKeyName)");
//                        localStorage.setItem("isHeadless", "\(isHeadlessStr)");
//                        
//                        // Mark as injected
//                        window.candidateDataInjected = true;
//                        
//                        console.log('✅ All candidate data injection completed');
//                        
//                        // Dispatch custom event for web app
//                        window.dispatchEvent(new CustomEvent('candidateDataReady', {
//                            detail: { 
//                                timestamp: Date.now(),
//                                injectedItems: ['candidateData', 'currentUserEWA', 'loggedinInfo', 'accessToken', 'keygaurd', 'keyname', 'isHeadless'],
//                                hasValidData: {
//                                    candidateData: candidateDataStr && candidateDataStr.trim() !== "",
//                                    currentUserData: currentUserStr && currentUserStr.trim() !== "",
//                                    candidateInfo: candidateInfoStr && candidateInfoStr.trim() !== ""
//                                }
//                            }
//                        }));
//                        
//                    } catch (error) {
//                        console.error('❌ Candidate data injection failed:', error);
//                        console.error('Error details:', {
//                            candidateData: "\(processedCandidateData)".substring(0, 50) + "...",
//                            currentUserJson: "\(processedCurrentUserJson)".substring(0, 50) + "...",
//                            candidateInfo: "\(processedCandidateInfo)".substring(0, 50) + "..."
//                        });
//                        // Clear the flag so we can retry
//                        window.candidateDataInjected = false;
//                    }
//                }
//                
//                // Execute based on document ready state
//                if (document.readyState === 'loading') {
//                    document.addEventListener('DOMContentLoaded', injectCandidateData);
//                } else {
//                    // DOM is already loaded, inject immediately
//                    injectCandidateData();
//                }
//            })();
//            """
//        }
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
//        
//    }
//}

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
//    var onTitleChange: ((String) -> Void)? = nil
//    // Enhanced parameters
//    let candidateData: String
//    let candidateInfo: String
//    let currentUserJson: String
//    let keyGuard: String
//    let keyName: String
//    let accessToken: String
//    let isHeadless: Bool
//   
//    var base64: String = ""
//    let title: String
//    
//    init(
//        url: URL,
//        isLoading: Binding<Bool>,
//        title: String = "",
//        candidateData: String = "",
//        candidateInfo: String = "",
//        base64: String = "",
//        currentUserJson: String = "",
//        keyGuard: String = "",
//        keyName: String = "",
//        accessToken: String = "",
//        isHeadless: Bool = true,
//        onTitleChange: ((String) -> Void)? = nil
//    ) {
//        self.url = url
//        self._isLoading = isLoading
//        self.title = title
//        self.candidateData = candidateData
//        self.candidateInfo = candidateInfo
//        self.currentUserJson = currentUserJson
//        self.keyGuard = keyGuard
//        self.keyName = keyName
//        self.accessToken = accessToken
//        self.isHeadless = isHeadless
//        self.onTitleChange = onTitleChange
//        self.base64 = base64
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let preferences = WKWebpagePreferences()
//        preferences.allowsContentJavaScript = true
//
//        let config = WKWebViewConfiguration()
//        config.defaultWebpagePreferences = preferences
//        config.websiteDataStore = .default()
//
//        // Early user script
//        let userScript = WKUserScript(
//            source: context.coordinator.createEarlyInjectionScript(),
//            injectionTime: .atDocumentStart,
//            forMainFrameOnly: false
//        )
//        config.userContentController.addUserScript(userScript)
//
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.navigationDelegate = context.coordinator
//        
//        // 🔹 Observe title + loading continuously
//            webView.addObserver(context.coordinator, forKeyPath: "title", options: .new, context: nil)
//            webView.addObserver(context.coordinator, forKeyPath: "loading", options: .new, context: nil)
//
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
//        // 🔹 Continuous KVO handling
//            override func observeValue(
//                forKeyPath keyPath: String?,
//                of object: Any?,
//                change: [NSKeyValueChangeKey : Any]?,
//                context: UnsafeMutableRawPointer?
//            ) {
//                guard let webView = object as? WKWebView else { return }
//
//                if keyPath == "title" {
//                    parent.onTitleChange?(webView.title ?? "Untitled")
//                } else if keyPath == "loading" {
//                    DispatchQueue.main.async {
//                        self.parent.isLoading = webView.isLoading
//                    }
//                }
//            }
//
//        // --- Lifecycle Delegates ---
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
//                injectJavaScriptIfNeeded(into: webView)
//            }
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.onTitleChange?(webView.title ?? "Untitled")
//            print("✅ Page finished loading: \(webView.url?.absoluteString ?? "unknown")")
//            injectJavaScriptIfNeeded(into: webView)
//        }
//
//        // --- Early script ---
//        func createEarlyInjectionScript() -> String {
//            """
//            (function() {
//                if (!window.candidateDataInjected) {
//                    console.log('🔧 Early setup for candidate data...');
//                    window.candidateDataInjected = false;
//                }
//            })();
//            """
//        }
//
//        // --- Main Injection ---
//        func createJavaScript() -> String {
//            // prepare Swift-side JSON strings
//            let processedBase64 = parent.base64.isEmpty ? "" : parent.base64
//            return """
//            (function() {
//                if (window.candidateDataInjected) {
//                    console.log('WebViewJS - Already injected, skipping...');
//                    return;
//                }
//                function b64DecodeUnicode(str) {
//                    try {
//                        var binary = atob(str);
//                        var bytes = [];
//                        for (var i = 0; i < binary.length; i++) {
//                            bytes.push('%' + ('00' + binary.charCodeAt(i).toString(16)).slice(-2));
//                        }
//                        return decodeURIComponent(bytes.join(''));
//                    } catch (e) {
//                        console.error("Base64 decode error", e);
//                        return "";
//                    }
//                }
//                function setField(selector, val) {
//                    if (!val && val !== 0) return;
//                    var el = document.querySelector(selector);
//                    if (!el) { console.log("No field for", selector); return; }
//                    el.value = String(val);
//                    el.dispatchEvent(new Event('input', { bubbles: true }));
//                    el.dispatchEvent(new Event('change', { bubbles: true }));
//                }
//                try {
//                    var raw = b64DecodeUnicode("\(processedBase64)");
//                    var data = JSON.parse(raw);
//                    setField("input[name='CompanyName'], #CompanyName", data.CompanyName || data.CompName);
//                    setField("input[name='Name'], #Name", data.Name);
//                    setField("input[name='AddETo'], input[name='RepEmail'], #Email", data.AddETo || data.RepEmail);
//                    setField("input[name='CompanyAddress'], input[name='ContactAddress'], #Address", data.CompanyAddress || data.ContactAddress);
//                    setField("input[name='Suite'], #Suite", data.Suite);
//                    setField("input[name='City'], #City", data.City);
//                    setField("input[name='State'], input[name='CompanyState'], #State", data.State || data.CompanyState);
//                    setField("input[name='CodeZip'], input[name='CompanyCodeZip'], #Zip", data.CodeZip || data.CompanyCodeZip);
//                    setField("input[name='Phone'], input[name='MainTelPhone'], #Phone", data.Phone || data.MainTelPhone);
//                    setField("input[name='Ext'], #Ext", data.Ext);
//                    setField("input[name='Fax'], #Fax", data.Fax);
//                    console.log("✅ Autofill applied from base64");
//                } catch (err) {
//                    console.error("Injection error", err);
//                }
//                window.candidateDataInjected = true;
//            })();
//            """
//        }
//
//        // --- Execute JS ---
//        private func injectJavaScriptIfNeeded(into webView: WKWebView) {
//            guard !hasInjectedForCurrentPage else { return }
//            hasInjectedForCurrentPage = true
//            let js = createJavaScript()
//            webView.evaluateJavaScript(js) { _, error in
//                if let error = error {
//                    print("❌ JS injection failed: \(error.localizedDescription)")
//                    self.hasInjectedForCurrentPage = false // allow retry
//                    DispatchQueue.main.async {
//                                    self.parent.isLoading = false // stop loader if unrecoverable
//                                }
//                } else {
//                    print("✅ JS injected successfully for: \(webView.url?.absoluteString ?? "unknown")")
//                                
//                                // Optional: verify localStorage/sessionStorage values
//                                let verificationJS = """
//                                !!document.querySelector('input[name="Name"]') && !!document.querySelector('input[name="CompanyName"]');
//                                """
//                                webView.evaluateJavaScript(verificationJS) { result, _ in
//                                    let fullyLoaded = (result as? Bool) ?? false
//                                    DispatchQueue.main.async {
//                                        self.parent.isLoading = !fullyLoaded ? true : false
//                                    }
//                                }
//                            }
//                }
//            }
//        }
//    }
//}


        
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
//                    print("WebViewJS - JS injection error: \(error.localizedDescription)")
//                    // Reset flag to allow retry
//                    self.hasInjectedForCurrentPage = false
//                } else {
//                    print("WebViewJS - JavaScript injected successfully for: \(webView.url?.absoluteString ?? "unknown")")
//                    
//                    // Read back values for verification (matching Android pattern)
//                    webView.evaluateJavaScript("localStorage.getItem('keygaurd');") { value,arg  in
//                        print("WebViewJS - keygaurd in localStorage: \(value ?? "null")")
//                    }
//                    
//                    webView.evaluateJavaScript("localStorage.getItem('keyname');") { value,arg  in
//                        print("WebViewJS - keyname in localStorage: \(value ?? "null")")
//                    }
//                    
//                    webView.evaluateJavaScript("localStorage.getItem('currentUser');") { value,arg  in
//                        print("WebViewJS - currentUser in localStorage: \(value != nil ? "SET" : "NULL")")
//                    }
//                    
//                    webView.evaluateJavaScript("localStorage.getItem('isHeadless');") { value,arg  in
//                        print("WebViewJS - isHeadless in localStorage: \(value ?? "null")")
//                    }
//                    
//                    webView.evaluateJavaScript("sessionStorage.getItem('cwaDetails');") { value,arg  in
//                        print("WebViewJS - cwaDetails in sessionStorage: \(value != nil ? "SET" : "NULL")")
//                    }
//                    
//                    webView.evaluateJavaScript("localStorage.getItem('isSubvendor');") { value,arg  in
//                        print("WebViewJS - isSubvendor in localStorage: \(value ?? "null")")
//                    }
//                    
//                    // Stop loading indicator after successful injection and verification
//                    DispatchQueue.main.async {
//                        self.parent.isLoading = false
//                    }
//                }
//            }
//        }
//        
//        private func validateDataBeforeInjection() {
//            print("WebViewJS - Data validation before injection:")
//            print("  candidateData: \(parent.candidateData.isEmpty ? "EMPTY" : "✓ \(parent.candidateData.count) chars")")
//            print("  candidateInfo: \(parent.candidateInfo.isEmpty ? "EMPTY" : "✓ \(parent.candidateInfo.count) chars")")
//            print("  currentUserJson: \(parent.currentUserJson.isEmpty ? "EMPTY" : "✓ \(parent.currentUserJson.count) chars")")
//            print("  keyGuard: \(parent.keyGuard.isEmpty ? "EMPTY" : "✓")")
//            print("  keyName: \(parent.keyName.isEmpty ? "EMPTY" : "✓")")
//            print("  accessToken: \(parent.accessToken.isEmpty ? "EMPTY" : "✓")")
//        }
//        
//        // Enhanced escaping function matching Android logic
//        private func escapeForJavaScript(_ string: String) -> String {
//            return string
//                .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
//                .replacingOccurrences(of: "\\", with: "\\\\")
//                .replacingOccurrences(of: "\"", with: "\\\"")
//                .replacingOccurrences(of: "\n", with: "\\n")
//                .replacingOccurrences(of: "\r", with: "\\r")
//                .replacingOccurrences(of: "\t", with: "\\t")
//        }
//        
//        // Additional escaping for backtick strings (matching Android's backtick escaping)
//        private func escapeForJavaScriptBackticks(_ string: String) -> String {
//            return string
//                .replacingOccurrences(of: "\\", with: "\\\\")
//                .replacingOccurrences(of: "`", with: "\\`")
//                .replacingOccurrences(of: "$", with: "\\$")
//        }
//    }
//}

import SwiftUI
import WebKit
import UniformTypeIdentifiers

//struct WebViewScreen: View {
//    let url: String
//    let title: String
//    
//    // Enhanced parameters
//    let candidateData: String
//    let candidateInfo: String
//    let currentUserJson: String
//    
//    @Binding var isLoading: Bool
//    var onTitleChange: ((String) -> Void)? = nil
//    
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject private var webViewManager = WebViewManager()
//    
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    
//    // Single initializer with default values for optional parameters
//    init(url: String,
//         title: String,
//         isLoading: Binding<Bool>,
//         candidateData: String = "",
//         candidateInfo: String = "",
//         currentUserJson: String = "",
//         onTitleChange: ((String) -> Void)? = nil) {
//        
//        self.url = url
//        self.title = title
//        self._isLoading = isLoading
//        self.candidateData = candidateData
//        self.candidateInfo = candidateInfo
//        self.currentUserJson = currentUserJson
//        self.onTitleChange = onTitleChange
//    }
//
//
//    var body: some View {
//        ZStack {
//            WebViewRepresentable(
//                url: url,
//                webViewManager: webViewManager,
//                isLoading: $isLoading,
//                onAlert: { message in
//                    alertMessage = message
//                    showingAlert = true
//                },
//                candidateData: candidateData,
//                candidateInfo: candidateInfo,
//                currentUserJson: currentUserJson
//            )
//            .alert("WebView Alert", isPresented: $showingAlert) {
//                Button("OK") { }
//            } message: {
//                Text(alertMessage)
//            }
//            
//            if isLoading {
//                // You can uncomment and customize your loading indicator here
//                 Color.black.opacity(0.3)
//                     .ignoresSafeArea()
//                 TriangleLoader()
////                ProgressView("Loading...")
////                    .scaleEffect(1.2)
////                    .progressViewStyle(CircularProgressViewStyle())
//            }
//        }
//        .onAppear {
//            // Debug print to verify data is being passed
//            print("🔍 WebViewScreen initialized with:")
//            print("  URL: \(url)")
//            print("  candidateData: \(candidateData.isEmpty ? "EMPTY" : "\(candidateData.count) characters")")
//            print("  candidateInfo: \(candidateInfo.isEmpty ? "EMPTY" : "\(candidateInfo.count) characters")")
//            print("  currentUserJson: \(currentUserJson.isEmpty ? "EMPTY" : "\(currentUserJson.count) characters")")
//        }
//    }
//}

// MARK: - Manager
//class WebViewManager: ObservableObject {
//    var webView: WKWebView?
//    
//    
//    
//    func evaluateJavaScript(_ script: String, completion: ((Any?, Error?) -> Void)? = nil) {
//        webView?.evaluateJavaScript(script, completionHandler: completion)
//    }
//}

//struct WebViewRepresentable: UIViewRepresentable {
//    let url: String
//    let webViewManager: WebViewManager
//    @Binding var isLoading: Bool
//    let onAlert: (String) -> Void
//    var onTitleChange: ((String) -> Void)? = nil
//    // Add these properties to pass candidate data
//    var candidateData: String = ""
//    var candidateInfo: String = ""
//    var currentUserJson: String = ""
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let configuration = WKWebViewConfiguration()
//        configuration.preferences.javaScriptEnabled = true
//        configuration.websiteDataStore = .default()
//        
//        // Add user script for early injection
//        let userScript = WKUserScript(
//            source: context.coordinator.createEarlyInjectionScript(),
//            injectionTime: .atDocumentStart,
//            forMainFrameOnly: false
//        )
//        configuration.userContentController.addUserScript(userScript)
//        
//        // JS message handlers
//        let userContentController = configuration.userContentController
//        userContentController.add(context.coordinator, name: "AndroidBlobDownloader")
//        userContentController.add(context.coordinator, name: "AndroidPrint")
//        
//        let webView = WKWebView(frame: .zero, configuration: configuration)
//        webView.navigationDelegate = context.coordinator
//        webView.uiDelegate = context.coordinator
//        
//        webViewManager.webView = webView
//        return webView
//    }
//    
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        if let url = URL(string: url), webView.url == nil {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self, onTitleChange: onTitleChange)
//    }
//    
//    // MARK: - Coordinator
//    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
//        
//        
//        let parent: WebViewRepresentable
//            private var hasInjectedForCurrentPage = false
//            private var currentPageURL: String = ""
//            private var titleObservation: NSKeyValueObservation?
//
//            init(_ parent: WebViewRepresentable) {
//                self.parent = parent
//                super.init()
//
//                // Observe title changes
//                titleObservation = parent.webViewManager.webView?.observe(\.title, options: [.new]) { [weak self] webView, change in
//                    guard let newTitle = change.newValue as? String, !newTitle.isEmpty else { return }
//                    print("📝 Title updated: \(newTitle)")
//                    self?.parent.onTitleChange?(newTitle)
//                }
//            }
//
//            deinit {
//                titleObservation?.invalidate()
//            }
//        var onTitleChange: ((String) -> Void)?
//
//        init(_ parent: WebViewRepresentable, onTitleChange: ((String) -> Void)? = nil) {
//            self.parent = parent
//            self.onTitleChange = onTitleChange
//        }
//        
//        // MARK: Navigation
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            parent.isLoading = true
//            hasInjectedForCurrentPage = false
//            print("🚀 Started loading: \(webView.url?.absoluteString ?? "unknown")")
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
//                injectCandidateDataIfNeeded(webView)
//            }
//        }
//        
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.isLoading = false
//            print("✅ Page finished loading: \(webView.url?.absoluteString ?? "unknown")")
//            
//            // Final injection attempt
//            injectCandidateDataIfNeeded(webView)
//            // Update title here 👇
//            if let title = webView.title {
//                onTitleChange?(title)         // ✅ This now bubbles up
//                parent.onTitleChange?(title)  // keep parent optional closure too
//            }
//            // Override window.print
//            let printScript = """
//                (function() {
//                    window.print = function() {
//                        window.webkit.messageHandlers.AndroidPrint.postMessage({});
//                    }
//                })();
//            """
//            webView.evaluateJavaScript(printScript, completionHandler: nil)
//        }
//        
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            parent.isLoading = false
//            hasInjectedForCurrentPage = false
//            print("WebView navigation failed: \(error.localizedDescription)")
//        }
//        
//        func webView(_ webView: WKWebView,
//                     decidePolicyFor navigationAction: WKNavigationAction,
//                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            decisionHandler(.allow)
//        }
//        
//        // MARK: - Message handlers
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            switch message.name {
//            case "AndroidBlobDownloader": handleBlobDownload(message: message)
//            case "AndroidPrint": handlePrint()
//            default: break
//            }
//        }
//        
//        // MARK: - Early injection script (runs at document start)
//        func createEarlyInjectionScript() -> String {
//            return """
//            (function() {
//                // Set up early storage before any scripts run
//                if (!window.candidateDataInjected) {
//                    console.log('🔧 Setting up early candidate data injection...');
//                    
//                    // Create a flag to prevent multiple injections
//                    window.candidateDataInjected = false;
//                    window.candidateDataEarlySetup = true;
//                    
//                    // Listen for the main injection
//                    document.addEventListener('DOMContentLoaded', function() {
//                        console.log('📄 DOM ready, candidate data should be injected soon');
//                    });
//                }
//            })();
//            """
//        }
//        
//        // MARK: - Main candidate data injection
//        private func injectCandidateDataIfNeeded(_ webView: WKWebView) {
//            guard !hasInjectedForCurrentPage else {
//                print("📝 Candidate data already injected for current page, skipping...")
//                return
//            }
//            parent.isLoading = false
//                print("✅ Page finished loading: \(webView.url?.absoluteString ?? "unknown")")
//
//                // Update page title
//                if let title = webView.title {
//                    parent.onTitleChange?(title)
//                }
//            
//            hasInjectedForCurrentPage = true
//            
//            let userDefaults = UserDefaults.standard
//            
//            // Get existing user data
//            let cwaDetails: [String: Any] = [
//                "ClientId": Int(userDefaults.string(forKey: "cmaClientId") ?? "") ?? 0,
//                "DivisionID": Int(userDefaults.string(forKey: "cmaDivisionId") ?? "") ?? 0,
//                "DivisionName": userDefaults.string(forKey: "cmaDivisionName") ?? "",
//                "ContactId": Int(userDefaults.string(forKey: "cmaContactId") ?? "") ?? 0,
//                "displayName": userDefaults.string(forKey: "cmaName") ?? "",
//                "ClientName": userDefaults.string(forKey: "cmaClientName") ?? "",
//                "siteName": userDefaults.string(forKey: "cmaClientName") ?? ""
//            ]
//            
//            let currentUser: [String: Any] = [
//                "accessToken": userDefaults.string(forKey: "accessToken") ?? "",
//                "requestingPartyToken": "Bearer",
//                "expiresIn": 1784285932,
//                "refreshToken": userDefaults.string(forKey: "refreshToken") ?? "",
//                "message": "success",
//                "username": userDefaults.string(forKey: "userName") ?? "",
//                "isPasswordChange": false
//            ]
//            
//            // Process candidate data
//            let processedCandidateData = parent.candidateData.isEmpty ? "{}" : escapeForJavaScript(parent.candidateData)
//            let processedCandidateInfo = parent.candidateInfo.isEmpty ? "{}" : escapeForJavaScript(parent.candidateInfo)
//            let processedCurrentUserJson = parent.currentUserJson.isEmpty ? "{}" : escapeForJavaScript(parent.currentUserJson)
//            
//            // Convert existing data to JSON
//            let cwaDetailsString = (try? JSONSerialization.data(withJSONObject: cwaDetails))
//                .flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
//            
//            let currentUserString = (try? JSONSerialization.data(withJSONObject: currentUser))
//                .flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
//            
//            let password = userDefaults.string(forKey: "password") ?? ""
//            let userName = userDefaults.string(forKey: "userName") ?? ""
//            let vendorType = userDefaults.string(forKey: "vendorType") ?? ""
//            
//            // Validation before injection
//            print("🔍 Data validation before injection:")
//            print("  candidateData: \(parent.candidateData.isEmpty ? "EMPTY" : "✓ \(parent.candidateData.count) chars")")
//            print("  candidateInfo: \(parent.candidateInfo.isEmpty ? "EMPTY" : "✓ \(parent.candidateInfo.count) chars")")
//            print("  currentUserJson: \(parent.currentUserJson.isEmpty ? "EMPTY" : "✓ \(parent.currentUserJson.count) chars")")
//            
//            // Build comprehensive injection script
//            let script = """
//            (function() {
//                // Prevent duplicate injections
//                if (window.candidateDataInjected) {
//                    console.log('📝 Candidate data already injected, skipping...');
//                    return;
//                }
//                
//                try {
//                    console.log('🚀 Starting comprehensive candidate data injection...');
//                    
//                    // Original user data
//                    localStorage.setItem('isHeadless', "true");
//                    sessionStorage.setItem('cwaDetails', `\(cwaDetailsString)`);
//                    localStorage.setItem('currentUser', `\(currentUserString)`);
//                    localStorage.setItem('keygaurd', `\(password)`);
//                    localStorage.setItem('isSubvendor', `\(vendorType)`);
//                    localStorage.setItem('keyname', `\(userName)`);
//                    
//                    // NEW: Enhanced candidate data injection
//                    const candidateDataStr = "\(processedCandidateData)";
//                    if (candidateDataStr && candidateDataStr.trim() !== "" && candidateDataStr !== "{}") {
//                        try {
//                            const candidateData = JSON.parse(candidateDataStr);
//                            localStorage.setItem("candidateData", JSON.stringify(candidateData));
//                            sessionStorage.setItem("candidateData", JSON.stringify(candidateData));
//                            console.log('✅ candidateData stored successfully');
//                        } catch (parseError) {
//                            console.error('❌ Failed to parse candidateData:', parseError);
//                        }
//                    } else {
//                        console.log('⚠️ candidateData is empty or invalid, skipping...');
//                    }
//                    
//                    // Enhanced current user data from parameters
//                    const currentUserJsonStr = "\(processedCurrentUserJson)";
//                    if (currentUserJsonStr && currentUserJsonStr.trim() !== "" && currentUserJsonStr !== "{}") {
//                        try {
//                            const currentUserData = JSON.parse(currentUserJsonStr);
//                            localStorage.setItem("currentUserEWA", JSON.stringify(currentUserData));
//                            sessionStorage.setItem("currentUserEWA", JSON.stringify(currentUserData));
//                            
//                            // Update access token if available
//                            if (currentUserData.accessToken) {
//                                localStorage.setItem("accessToken", currentUserData.accessToken);
//                            }
//                            console.log('✅ currentUserEWA stored successfully');
//                        } catch (parseError) {
//                            console.error('❌ Failed to parse currentUserJson:', parseError);
//                        }
//                    } else {
//                        console.log('⚠️ currentUserJson is empty or invalid, using fallback...');
//                    }
//                    
//                    // Candidate info (demographics)
//                    const candidateInfoStr = "\(processedCandidateInfo)";
//                    if (candidateInfoStr && candidateInfoStr.trim() !== "" && candidateInfoStr !== "{}") {
//                        try {
//                            const candidateInfo = JSON.parse(candidateInfoStr);
//                            sessionStorage.setItem("loggedinInfo", JSON.stringify(candidateInfo));
//                            localStorage.setItem("loggedinInfo", JSON.stringify(candidateInfo));
//                            console.log('✅ loggedinInfo stored successfully');
//                        } catch (parseError) {
//                            console.error('❌ Failed to parse candidateInfo:', parseError);
//                        }
//                    } else {
//                        console.log('⚠️ candidateInfo is empty or invalid, skipping...');
//                    }
//                    
//                    // Mark as successfully injected
//                    window.candidateDataInjected = true;
//                    
//                    console.log('✅ All candidate data injection completed successfully');
//                    
//                    // Dispatch custom event for web app
//                    window.dispatchEvent(new CustomEvent('candidateDataReady', {
//                        detail: { 
//                            timestamp: Date.now(),
//                            injectedItems: ['candidateData', 'currentUserEWA', 'loggedinInfo', 'accessToken', 'keygaurd', 'keyname', 'isHeadless'],
//                            source: 'WebViewRepresentable',
//                            hasValidData: {
//                                candidateData: candidateDataStr && candidateDataStr.trim() !== "" && candidateDataStr !== "{}",
//                                currentUserData: currentUserJsonStr && currentUserJsonStr.trim() !== "" && currentUserJsonStr !== "{}",
//                                candidateInfo: candidateInfoStr && candidateInfoStr.trim() !== "" && candidateInfoStr !== "{}"
//                            }
//                        }
//                    }));
//                    
//                    // Also dispatch the original event name for compatibility
//                    window.dispatchEvent(new CustomEvent('candidateDataLoaded', {
//                        detail: {
//                            candidateData: candidateDataStr ? JSON.parse(candidateDataStr || "{}") : {},
//                            demographics: candidateInfoStr ? JSON.parse(candidateInfoStr || "{}") : {}
//                        }
//                    }));
//                    
//                } catch (error) {
//                    console.error('❌ Candidate data injection failed:', error);
//                    console.error('Error details:', {
//                        candidateDataLength: "\(processedCandidateData)".length,
//                        candidateInfoLength: "\(processedCandidateInfo)".length,
//                        currentUserJsonLength: "\(processedCurrentUserJson)".length
//                    });
//                    // Reset flag to allow retry
//                    window.candidateDataInjected = false;
//                }
//            })();
//            """
//            
//            webView.evaluateJavaScript(script) { result, error in
//                if let error = error {
//                    print("❌ Candidate data injection failed: \(error.localizedDescription)")
//                    self.hasInjectedForCurrentPage = false // Allow retry
//                } else {
//                    print("✅ Candidate data injection successful for: \(webView.url?.absoluteString ?? "unknown")")
//                }
//            }
//        }
//        
//        // MARK: - Utility function for JavaScript escaping
//        private func escapeForJavaScript(_ string: String) -> String {
//            return string
//                .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
//                .replacingOccurrences(of: "\\", with: "\\\\")
//                .replacingOccurrences(of: "\"", with: "\\\"")
//                .replacingOccurrences(of: "\n", with: "\\n")
//                .replacingOccurrences(of: "\r", with: "\\r")
//                .replacingOccurrences(of: "\t", with: "\\t")
//        }
//        
//        // MARK: - Existing helper methods (unchanged)
//        private func handleBlobDownload(message: WKScriptMessage) {
//            guard let body = message.body as? [String: Any],
//                  let base64String = body["base64"] as? String,
//                  let mimeType = body["mimeType"] as? String,
//                  let contentDisposition = body["contentDisposition"] as? String,
//                  let data = Data(base64Encoded: base64String) else {
//                return
//            }
//            
//            let filename = extractFilename(from: contentDisposition, mimeType: mimeType)
//            
//            if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                let fileURL = documentsPath.appendingPathComponent(filename)
//                do {
//                    try data.write(to: fileURL)
//                    parent.onAlert("File saved: \(filename)")
//                } catch {
//                    parent.onAlert("Failed to save: \(error.localizedDescription)")
//                }
//            }
//        }
//        
//        private func handlePrint() {
//            guard let webView = parent.webViewManager.webView else { return }
//            
//            let printController = UIPrintInteractionController.shared
//            let printInfo = UIPrintInfo.printInfo()
//            printInfo.outputType = .general
//            printInfo.jobName = "Web Page"
//            
//            printController.printInfo = printInfo
//            printController.printFormatter = webView.viewPrintFormatter()
//            
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = windowScene.windows.first,
//               let rootViewController = window.rootViewController {
//                printController.present(animated: true, completionHandler: nil)
//            }
//        }
//        
//        private func extractFilename(from contentDisposition: String, mimeType: String) -> String {
//            if let range = contentDisposition.range(of: "filename=") {
//                let filename = String(contentDisposition[range.upperBound...])
//                    .trimmingCharacters(in: .whitespacesAndNewlines)
//                    .replacingOccurrences(of: "\"", with: "")
//                if !filename.isEmpty { return filename }
//            }
//            
//            let timestamp = Int(Date().timeIntervalSince1970)
//            switch mimeType {
//            case "application/pdf": return "document_\(timestamp).pdf"
//            case "image/png": return "image_\(timestamp).png"
//            case "image/jpeg": return "image_\(timestamp).jpg"
//            case "text/plain": return "document_\(timestamp).txt"
//            default: return "file_\(timestamp)"
//            }
//        }
//    }
//}


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
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let preferences = WKWebpagePreferences()
//        preferences.allowsContentJavaScript = true
//
//        let config = WKWebViewConfiguration()
//        config.defaultWebpagePreferences = preferences
//        config.websiteDataStore = .default()
//        
//        // Inject JavaScript as early as possible using user script
//        let userScript = WKUserScript(
//            source: context.coordinator.createEarlyInjectionScript(),
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
//    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
//        
//        
//        let parent: WebView
//        private var hasInjectedForCurrentPage = false
//        private var currentPageURL: String = ""
//        private var titleObservation: NSKeyValueObservation?
//        
//        init(_ parent: WebView) {
//            self.parent = parent
//            super.init()
//            
//            // Observe title changes
////            titleObservation = parent.WebView.webView?.observe(\.title, options: [.new]) { [weak self] webView, change in
////                guard let newTitle = change.newValue as? String, !newTitle.isEmpty else { return }
////                print("📝 Title updated: \(newTitle)")
////                self?.parent.onTitleChange?(newTitle)
////            }
//        }
//        
//        deinit {
//            titleObservation?.invalidate()
//        }
//        var onTitleChange: ((String) -> Void)?
//        
//        init(_ parent: WebView, onTitleChange: ((String) -> Void)? = nil) {
//            self.parent = parent
//            self.onTitleChange = onTitleChange
//        }
//        
//        // MARK: Navigation
//        // MARK: Navigation
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            parent.isLoading = true
//            hasInjectedForCurrentPage = false
//            print("🚀 Started loading: \(webView.url?.absoluteString ?? "unknown")")
//        }
//
//        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//            let newURL = webView.url?.absoluteString ?? ""
//            if newURL != currentPageURL {
//                currentPageURL = newURL
//                hasInjectedForCurrentPage = false
//                print("📄 Page committed: \(newURL)")
//            }
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            
//            parent.isLoading = false
//            print("✅ Page finished loading: \(webView.url?.absoluteString ?? "unknown")")
//            
//            // Final injection attempt
//            injectCandidateDataIfNeeded(webView)
//            // Update title here 👇
//            if let title = webView.title {
//                onTitleChange?(title)         // ✅ This now bubbles up
//                parent.onTitleChange?(title)  // keep parent optional closure too
//            }
//            
//            
//            // Override window.print
//            let printScript = """
//                (function() {
//                    window.print = function() {
//                        window.webkit.messageHandlers.AndroidPrint.postMessage({});
//                    }
//                })();
//            """
//            webView.evaluateJavaScript(printScript, completionHandler: nil)
//        }
//        
//        
//        
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            parent.isLoading = false
//            hasInjectedForCurrentPage = false
//            print("WebView navigation failed: \(error.localizedDescription)")
//        }
//        
//        func webView(_ webView: WKWebView,
//                     decidePolicyFor navigationAction: WKNavigationAction,
//                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            decisionHandler(.allow)
//        }
//        
//        // MARK: - Message handlers
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            switch message.name {
//            case "AndroidBlobDownloader": handleBlobDownload(message: message)
//           // case "AndroidPrint": handlePrint()
//            default: break
//            }
//        }
//        
//        // MARK: - Early injection script (runs at document start)
//        func createEarlyInjectionScript() -> String {
//            return """
//            (function() {
//                // Set up early storage before any scripts run
//                if (!window.candidateDataInjected) {
//                    console.log('🔧 Setting up early candidate data injection...');
//                    
//                    // Create a flag to prevent multiple injections
//                    window.candidateDataInjected = false;
//                    window.candidateDataEarlySetup = true;
//                    
//                    // Listen for the main injection
//                    document.addEventListener('DOMContentLoaded', function() {
//                        console.log('📄 DOM ready, candidate data should be injected soon');
//                    });
//                }
//            })();
//            """
//        }
//        
//        // MARK: - Main candidate data injection
//        private func injectCandidateDataIfNeeded(_ webView: WKWebView) {
//            guard !hasInjectedForCurrentPage else {
//                print("📝 Candidate data already injected for current page, skipping...")
//                return
//            }
//           // parent.isLoading = false
//            print("✅ Page finished loading: \(webView.url?.absoluteString ?? "unknown")")
//            
//            // Update page title
//            if let title = webView.title {
//                parent.onTitleChange?(title)
//            }
//            
//            hasInjectedForCurrentPage = true
//            
//            let userDefaults = UserDefaults.standard
//            
//            // Get existing user data
//            let cwaDetails: [String: Any] = [
//                "ClientId": Int(userDefaults.string(forKey: "cmaClientId") ?? "") ?? 0,
//                "DivisionID": Int(userDefaults.string(forKey: "cmaDivisionId") ?? "") ?? 0,
//                "DivisionName": userDefaults.string(forKey: "cmaDivisionName") ?? "",
//                "ContactId": Int(userDefaults.string(forKey: "cmaContactId") ?? "") ?? 0,
//                "displayName": userDefaults.string(forKey: "cmaName") ?? "",
//                "ClientName": userDefaults.string(forKey: "cmaClientName") ?? "",
//                "siteName": userDefaults.string(forKey: "cmaClientName") ?? ""
//            ]
//            
//            let currentUser: [String: Any] = [
//                "accessToken": userDefaults.string(forKey: "accessToken") ?? "",
//                "requestingPartyToken": "Bearer",
//                "expiresIn": 1784285932,
//                "refreshToken": userDefaults.string(forKey: "refreshToken") ?? "",
//                "message": "success",
//                "username": userDefaults.string(forKey: "userName") ?? "",
//                "isPasswordChange": false
//            ]
//            
//            // Process candidate data
//            let processedCandidateData = parent.candidateData.isEmpty ? "{}" : escapeForJavaScript(parent.candidateData)
//            let processedCandidateInfo = parent.candidateInfo.isEmpty ? "{}" : escapeForJavaScript(parent.candidateInfo)
//            let processedCurrentUserJson = parent.currentUserJson.isEmpty ? "{}" : escapeForJavaScript(parent.currentUserJson)
//            
//            // Convert existing data to JSON
//            let cwaDetailsString = (try? JSONSerialization.data(withJSONObject: cwaDetails))
//                .flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
//            
//            let currentUserString = (try? JSONSerialization.data(withJSONObject: currentUser))
//                .flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
//            
//            let password = userDefaults.string(forKey: "password") ?? ""
//            let userName = userDefaults.string(forKey: "userName") ?? ""
//            let vendorType = userDefaults.string(forKey: "vendorType") ?? ""
//            
//            // Validation before injection
//            print("🔍 Data validation before injection:")
//            print("  candidateData: \(parent.candidateData.isEmpty ? "EMPTY" : "✓ \(parent.candidateData.count) chars")")
//            print("  candidateInfo: \(parent.candidateInfo.isEmpty ? "EMPTY" : "✓ \(parent.candidateInfo.count) chars")")
//            print("  currentUserJson: \(parent.currentUserJson.isEmpty ? "EMPTY" : "✓ \(parent.currentUserJson.count) chars")")
//            
//            // Build comprehensive injection script
//            let script = """
//            (function() {
//                // Prevent duplicate injections
//                if (window.candidateDataInjected) {
//                    console.log('📝 Candidate data already injected, skipping...');
//                    return;
//                }
//                
//                try {
//                    console.log('🚀 Starting comprehensive candidate data injection...');
//                    
//                    // Original user data
//                    localStorage.setItem('isHeadless', "true");
//                    sessionStorage.setItem('cwaDetails', `\(cwaDetailsString)`);
//                    localStorage.setItem('currentUser', `\(currentUserString)`);
//                    localStorage.setItem('keygaurd', `\(password)`);
//                    localStorage.setItem('isSubvendor', `\(vendorType)`);
//                    localStorage.setItem('keyname', `\(userName)`);
//                    
//                    // NEW: Enhanced candidate data injection
//                    const candidateDataStr = "\(processedCandidateData)";
//                    if (candidateDataStr && candidateDataStr.trim() !== "" && candidateDataStr !== "{}") {
//                        try {
//                            const candidateData = JSON.parse(candidateDataStr);
//                            localStorage.setItem("candidateData", JSON.stringify(candidateData));
//                            sessionStorage.setItem("candidateData", JSON.stringify(candidateData));
//                            console.log('✅ candidateData stored successfully');
//                        } catch (parseError) {
//                            console.error('❌ Failed to parse candidateData:', parseError);
//                        }
//                    } else {
//                        console.log('⚠️ candidateData is empty or invalid, skipping...');
//                    }
//                    
//                    // Enhanced current user data from parameters
//                    const currentUserJsonStr = "\(processedCurrentUserJson)";
//                    if (currentUserJsonStr && currentUserJsonStr.trim() !== "" && currentUserJsonStr !== "{}") {
//                        try {
//                            const currentUserData = JSON.parse(currentUserJsonStr);
//                            localStorage.setItem("currentUserEWA", JSON.stringify(currentUserData));
//                            sessionStorage.setItem("currentUserEWA", JSON.stringify(currentUserData));
//                            
//                            // Update access token if available
//                            if (currentUserData.accessToken) {
//                                localStorage.setItem("accessToken", currentUserData.accessToken);
//                            }
//                            console.log('✅ currentUserEWA stored successfully');
//                        } catch (parseError) {
//                            console.error('❌ Failed to parse currentUserJson:', parseError);
//                        }
//                    } else {
//                        console.log('⚠️ currentUserJson is empty or invalid, using fallback...');
//                    }
//                    
//                    // Candidate info (demographics)
//                    const candidateInfoStr = "\(processedCandidateInfo)";
//                    if (candidateInfoStr && candidateInfoStr.trim() !== "" && candidateInfoStr !== "{}") {
//                        try {
//                            const candidateInfo = JSON.parse(candidateInfoStr);
//                            sessionStorage.setItem("loggedinInfo", JSON.stringify(candidateInfo));
//                            localStorage.setItem("loggedinInfo", JSON.stringify(candidateInfo));
//                            console.log('✅ loggedinInfo stored successfully');
//                        } catch (parseError) {
//                            console.error('❌ Failed to parse candidateInfo:', parseError);
//                        }
//                    } else {
//                        console.log('⚠️ candidateInfo is empty or invalid, skipping...');
//                    }
//                    
//                    // Mark as successfully injected
//                    window.candidateDataInjected = true;
//                    
//                    console.log('✅ All candidate data injection completed successfully');
//                    
//                    // Dispatch custom event for web app
//                    window.dispatchEvent(new CustomEvent('candidateDataReady', {
//                        detail: { 
//                            timestamp: Date.now(),
//                            injectedItems: ['candidateData', 'currentUserEWA', 'loggedinInfo', 'accessToken', 'keygaurd', 'keyname', 'isHeadless'],
//                            source: 'WebViewRepresentable',
//                            hasValidData: {
//                                candidateData: candidateDataStr && candidateDataStr.trim() !== "" && candidateDataStr !== "{}",
//                                currentUserData: currentUserJsonStr && currentUserJsonStr.trim() !== "" && currentUserJsonStr !== "{}",
//                                candidateInfo: candidateInfoStr && candidateInfoStr.trim() !== "" && candidateInfoStr !== "{}"
//                            }
//                        }
//                    }));
//                    
//                    // Also dispatch the original event name for compatibility
//                    window.dispatchEvent(new CustomEvent('candidateDataLoaded', {
//                        detail: {
//                            candidateData: candidateDataStr ? JSON.parse(candidateDataStr || "{}") : {},
//                            demographics: candidateInfoStr ? JSON.parse(candidateInfoStr || "{}") : {}
//                        }
//                    }));
//                    
//                } catch (error) {
//                    console.error('❌ Candidate data injection failed:', error);
//                    console.error('Error details:', {
//                        candidateDataLength: "\(processedCandidateData)".length,
//                        candidateInfoLength: "\(processedCandidateInfo)".length,
//                        currentUserJsonLength: "\(processedCurrentUserJson)".length
//                    });
//                    // Reset flag to allow retry
//                    window.candidateDataInjected = false;
//                }
//            })();
//            """
//            
//            webView.evaluateJavaScript(script) { result, error in
//                if let error = error {
//                    print("❌ Candidate data injection failed: \(error.localizedDescription)")
//                    self.hasInjectedForCurrentPage = false // Allow retry
//                } else {
//                    print("✅ Candidate data injection successful for: \(webView.url?.absoluteString ?? "unknown")")
//                }
//            }
//        }
//        
//        // MARK: - Utility function for JavaScript escaping
//        private func escapeForJavaScript(_ string: String) -> String {
//            return string
//                .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
//                .replacingOccurrences(of: "\\", with: "\\\\")
//                .replacingOccurrences(of: "\"", with: "\\\"")
//                .replacingOccurrences(of: "\n", with: "\\n")
//                .replacingOccurrences(of: "\r", with: "\\r")
//                .replacingOccurrences(of: "\t", with: "\\t")
//        }
//        
//        // MARK: - Existing helper methods (unchanged)
//        private func handleBlobDownload(message: WKScriptMessage) {
//            guard let body = message.body as? [String: Any],
//                  let base64String = body["base64"] as? String,
//                  let mimeType = body["mimeType"] as? String,
//                  let contentDisposition = body["contentDisposition"] as? String,
//                  let data = Data(base64Encoded: base64String) else {
//                return
//            }
//            
//            let filename = extractFilename(from: contentDisposition, mimeType: mimeType)
//            
//            if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                let fileURL = documentsPath.appendingPathComponent(filename)
////                do {
////                    try data.write(to: fileURL)
////                    parent.onAlert("File saved: \(filename)")
////                } catch {
////                    parent.onAlert("Failed to save: \(error.localizedDescription)")
////                }
//            }
//        }
//        
////        private func handlePrint() {
////            guard let webView = parent.webViewManager.webView else { return }
////            
////            let printController = UIPrintInteractionController.shared
////            let printInfo = UIPrintInfo.printInfo()
////            printInfo.outputType = .general
////            printInfo.jobName = "Web Page"
////            
////            printController.printInfo = printInfo
////            printController.printFormatter = webView.viewPrintFormatter()
////            
////            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
////               let window = windowScene.windows.first,
////               let rootViewController = window.rootViewController {
////                printController.present(animated: true, completionHandler: nil)
////            }
////        }
//        
//        private func extractFilename(from contentDisposition: String, mimeType: String) -> String {
//            if let range = contentDisposition.range(of: "filename=") {
//                let filename = String(contentDisposition[range.upperBound...])
//                    .trimmingCharacters(in: .whitespacesAndNewlines)
//                    .replacingOccurrences(of: "\"", with: "")
//                if !filename.isEmpty { return filename }
//            }
//            
//            let timestamp = Int(Date().timeIntervalSince1970)
//            switch mimeType {
//            case "application/pdf": return "document_\(timestamp).pdf"
//            case "image/png": return "image_\(timestamp).png"
//            case "image/jpeg": return "image_\(timestamp).jpg"
//            case "text/plain": return "document_\(timestamp).txt"
//            default: return "file_\(timestamp)"
//            }
//        }
//        
//        
//    }
//        
//    }

//import SwiftUI
//import WebKit
//
//struct WebView: UIViewRepresentable {
//    let url: URL
//    @Binding var isLoading: Bool
//   let payload: WebViewPayload
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
//        let preferences = WKWebpagePreferences()
//        preferences.allowsContentJavaScript = true
//
//        let config = WKWebViewConfiguration()
//        config.defaultWebpagePreferences = preferences
//        config.websiteDataStore = .default()
//
//        // Add message handler for debug messages from the page
//        config.userContentController.add(context.coordinator, name: "debugHandler")
//
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.navigationDelegate = context.coordinator
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        if uiView.url != url {
//            print("🔄 Loading WebView URL: \(url.absoluteString)")
//            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
//            uiView.load(request)
//        }
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
//        var parent: WebView
//        private var injectionAttempts = 0
//        private let maxAttempts = 3
//
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            DispatchQueue.main.async { self.parent.isLoading = true }
//            injectionAttempts = 0
//            print("🚀 Navigation started: \(webView.url?.absoluteString ?? "unknown")")
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            DispatchQueue.main.async { self.parent.isLoading = false }
//            parent.onTitleChange?(webView.title ?? "Untitled")
//            print("✅ Navigation finished: \(webView.url?.absoluteString ?? "unknown")")
//
//            // small delay to allow page scripts to settle
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.injectDataWithRetry(webView)
//            }
//        }
//
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            DispatchQueue.main.async { self.parent.isLoading = false }
//            print("❌ Navigation failed: \(error.localizedDescription)")
//        }
//
//        // MARK: - Injection with retry
//        private func injectDataWithRetry(_ webView: WKWebView) {
//            guard injectionAttempts < maxAttempts else {
//                print("❌ Max injection attempts reached")
//                return
//            }
//
//            injectionAttempts += 1
//            print("🔄 Injection attempt \(injectionAttempts)/\(maxAttempts)")
//
//            let script = createInjectionScript()
//
//            webView.evaluateJavaScript(script) { result, error in
//                if let error = error {
//                    print("❌ Injection failed (attempt \(self.injectionAttempts)): \(error.localizedDescription)")
//                    // Try again after brief delay
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.injectDataWithRetry(webView)
//                    }
//                } else {
//                    print("✅ Data injection JS executed (attempt \(self.injectionAttempts))")
//                    // After JS ran, ask page to verify storage and return results via debugHandler
//                    self.verifyInjection(webView)
//                }
//            }
//        }
//
//        // MARK: - Build safe JS that parses stringified JSON inside the page
////        private func createInjectionScript() -> String {
////            let userDefaults = UserDefaults.standard
////
////            // Build CWA details and fallback currentUser on Swift side
////            let cwaDetails: [String: Any] = [
////                "ClientId": Int(userDefaults.string(forKey: "cmaClientId") ?? "") ?? 95108,
////                "DivisionID": Int(userDefaults.string(forKey: "cmaDivisionId") ?? "") ?? 6,
////                "DivisionName": userDefaults.string(forKey: "cmaDivisionName") ?? "On Call Counsel - Gov",
////                "ContactId": Int(userDefaults.string(forKey: "cmaContactId") ?? "") ?? 423872,
////                "displayName": userDefaults.string(forKey: "cmaName") ?? "TemPositions IT",
////                "ClientName": userDefaults.string(forKey: "cmaClientName") ?? "Test - Office of Asylum Seeker Operations",
////                "siteName": userDefaults.string(forKey: "cmaClientName") ?? "Test - Office of Asylum Seeker Operations",
////                "Master": 95012,
////                "ClientContactInfoId": 62603
////            ]
////
////            let currentUserFallback: [String: Any] = [
////                "accessToken": userDefaults.string(forKey: "accessToken") ?? parent.accessToken,
////                "requestingPartyToken": "Bearer",
////                "expiresIn": 2073600,
////                "refreshToken": userDefaults.string(forKey: "refreshToken") ?? "",
////                "message": "success",
////                "username": userDefaults.string(forKey: "userName") ?? parent.keyName,
////                "isPasswordChange": false
////            ]
////
////            // Convert to JSON strings (raw, unescaped)
////            let cwaDetailsJsonRaw = toJSONString(cwaDetails) // e.g. {"a":1}
////            let currentUserFallbackJsonRaw = toJSONString(currentUserFallback)
////
////            // Decide which current user JSON to use: if parent.currentUserJson is empty -> fallback
////            let chosenCurrentUserRaw = parent.currentUserJson.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? currentUserFallbackJsonRaw : parent.currentUserJson
////
////            // Now escape them for safe insertion into JS single-quoted string literals
////            let cwaDetailsEscaped = escapeForJSSingleQuotedString(cwaDetailsJsonRaw)
////            let currentUserEscaped = escapeForJSSingleQuotedString(chosenCurrentUserRaw)
////
////            // Escape other optional pieces that may be raw JSON strings
////            let candidateDataToInject = parent.candidateData.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "{}" : parent.candidateData
////            let candidateInfoToInject = parent.candidateInfo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "{}" : parent.candidateInfo
////            let candidateDataEscaped = escapeForJSSingleQuotedString(candidateDataToInject)
////            let candidateInfoEscaped = escapeForJSSingleQuotedString(candidateInfoToInject)
////
////            // Additional small items
////            let keyGuardValue = userDefaults.string(forKey: "password") ?? parent.keyGuard
////            let keyGuardEscaped = escapeForJSSingleQuotedString(keyGuardValue)
////            let keyNameValue = userDefaults.string(forKey: "userName") ?? parent.keyName
////            let keyNameEscaped = escapeForJSSingleQuotedString(keyNameValue)
////            let isSubvendor = userDefaults.string(forKey: "vendorType") ?? "0"
////            let accessTokenValue = userDefaults.string(forKey: "accessToken") ?? parent.accessToken
////            let accessTokenEscaped = escapeForJSSingleQuotedString(accessTokenValue)
////
////            // The JS below:
////            // - Parses each injected string with JSON.parse
////            // - Wraps everything in try/catch and posts detailed error info to debugHandler
////            let script = """
////            (function() {
////                try {
////                    console.log('🔧 Starting comprehensive safe data injection...');
////                    // Basic flags
////                    localStorage.setItem('isHeadless', 'true');
////                    localStorage.setItem('keygaurd', '\(keyGuardEscaped)');
////                    localStorage.setItem('keyname', '\(keyNameEscaped)');
////                    localStorage.setItem('isSubvendor', '\(isSubvendor)');
////
////                    // Parse and set CWA details
////                    var cwaDetailsStr = '\(cwaDetailsEscaped)';
////                    var cwaDetailsObj = {};
////                    try {
////                        cwaDetailsObj = JSON.parse(cwaDetailsStr);
////                        sessionStorage.setItem('cwaDetails', JSON.stringify(cwaDetailsObj));
////                        console.log('✅ cwaDetails set', cwaDetailsObj);
////                    } catch (e) {
////                        console.warn('⚠️ Failed to parse cwaDetails:', e);
////                    }
////
////                    // Parse and set currentUser
////                    var currentUserStr = '\(currentUserEscaped)';
////                    try {
////                        var currentUserObj = JSON.parse(currentUserStr);
////                        localStorage.setItem('currentUser', JSON.stringify(currentUserObj));
////                        console.log('✅ currentUser set', currentUserObj);
////                    } catch (e) {
////                        console.warn('⚠️ Failed to parse currentUser:', e);
////                    }
////
////                    // Candidate data (optional)
////                    var candidateDataStr = '\(candidateDataEscaped)';
////                    if (candidateDataStr && candidateDataStr !== '{}' && candidateDataStr !== '') {
////                        try {
////                            var candidateObj = JSON.parse(candidateDataStr);
////                            localStorage.setItem('candidateData', JSON.stringify(candidateObj));
////                            sessionStorage.setItem('candidateData', JSON.stringify(candidateObj));
////                            console.log('✅ candidateData stored', candidateObj);
////                        } catch (e) {
////                            console.warn('⚠️ candidateData parse error:', e);
////                        }
////                    }
////
////                    // Candidate info (optional)
////                    var candidateInfoStr = '\(candidateInfoEscaped)';
////                    if (candidateInfoStr && candidateInfoStr !== '{}' && candidateInfoStr !== '') {
////                        try {
////                            var candidateInfoObj = JSON.parse(candidateInfoStr);
////                            sessionStorage.setItem('loggedinInfo', JSON.stringify(candidateInfoObj));
////                            localStorage.setItem('loggedinInfo', JSON.stringify(candidateInfoObj));
////                            console.log('✅ candidateInfo stored', candidateInfoObj);
////                        } catch (e) {
////                            console.warn('⚠️ candidateInfo parse error:', e);
////                        }
////                    }
////
////                    localStorage.setItem('accessToken', '\(accessTokenEscaped)');
////
////                    // Notify native that injection completed
////                    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.debugHandler) {
////                        window.webkit.messageHandlers.debugHandler.postMessage({
////                            type: 'injection_success',
////                            timestamp: new Date().toISOString()
////                        });
////                    }
////
////                    // Dispatch event for any in-page listeners
////                    window.dispatchEvent(new CustomEvent('dataInjectionComplete', { detail: { success: true, timestamp: Date.now() } }));
////
////                    return { success: true };
////                } catch (err) {
////                    console.error('❌ Data injection top-level error', err);
////                    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.debugHandler) {
////                        window.webkit.messageHandlers.debugHandler.postMessage({
////                            type: 'injection_error',
////                            message: err && err.message ? err.message : String(err),
////                            stack: err && err.stack ? err.stack : null,
////                            timestamp: new Date().toISOString()
////                        });
////                    }
////                    return { success: false, error: err && err.message ? err.message : String(err) };
////                }
////            })();
////            """
////            return script
////        }
//        
////        private func createInjectionScript() -> String {
////            let userDefaults = UserDefaults.standard
////
////            // Build CWA details
////            let cwaDetails: [String: Any] = [
////                "ClientId": Int(userDefaults.string(forKey: "cmaClientId") ?? "") ?? 0,
////                "DivisionID": Int(userDefaults.string(forKey: "cmaDivisionId") ?? "") ?? 0,
////                "DivisionName": userDefaults.string(forKey: "cmaDivisionName") ?? "",
////                "ContactId": Int(userDefaults.string(forKey: "cmaContactId") ?? "") ?? 0,
////                "displayName": userDefaults.string(forKey: "cmaName") ?? "",
////                "ClientName": userDefaults.string(forKey: "cmaClientName") ?? "",
////                "siteName": userDefaults.string(forKey: "cmaClientName") ?? "",
////                "Master": Int(userDefaults.string(forKey: "Master") ?? "") ?? 0,
////                "ClientContactInfoId": Int(userDefaults.string(forKey: "ClientContactInfoId") ?? "") ?? 0
////            ]
////            
////            let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
////            let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
////            let expiresIn = UserDefaults.standard.integer(forKey: "expiresIn")
////            let passworde = UserDefaults.standard.string(forKey: "Password") ?? ""
////            let usernamee = UserDefaults.standard.string(forKey: "Username") ?? ""
////            
////            let currentUser: [String: Any] = [
////               
////
////                // Build JSON for currentUserCWA
////                    "accessToken": accessToken,
////                    "refreshToken": refreshToken,
////                    "expiresIn": expiresIn,
////                    "requestingPartyToken": "Bearer",
////                    "message": "success",
////                    "isPasswordChange": false,
////                    "username": usernamee
////                ]
////            let fetched = UserDefaults.standard.dictionary(forKey: "cwaDetails")
////           print(fetched)
////            
////            
////            let cwaDetailsJson = escapeForJavaScript(toJSONString(parent.payload.cwaDetails ?? [:]))
////            let currentUserJson = escapeForJavaScript(toJSONString(currentUser))
////            let password = escapeForJavaScript(userDefaults.string(forKey: "Password") ?? parent.keyGuard)
////            let userName = escapeForJavaScript(userDefaults.string(forKey: "Username") ?? parent.keyName)
////            let vendorType = escapeForJavaScript(userDefaults.string(forKey: "IsSubVendor") ?? "0")
////            print(cwaDetailsJson)
////
////            return """
////            (function() {
////                try {
////                    console.log("🔧 Injecting data into localStorage / sessionStorage...");
////                    
////                    localStorage.setItem('isHeadless', "true");
////                    sessionStorage.setItem('cwaDetails', `\(cwaDetailsJson)`);
////                    localStorage.setItem('currentUser', `\(currentUserJson)`);
////                    localStorage.setItem('keygaurd', `\(password)`);
////                    localStorage.setItem('isSubvendor', `\(vendorType)`);
////                    localStorage.setItem('keyname', `\(userName)`);
////                    
////                    console.log("✅ Injection complete");
////                    return { success: true };
////                } catch (e) {
////                    console.error("❌ Injection error:", e);
////                    return { success: false, error: e.message };
////                }
////            })();
////            """
////        }
//        
//        private func createInjectionScript() -> String {
//            let userDefaults = UserDefaults.standard
//            
//            let accessToken = userDefaults.string(forKey: "accessToken") ?? ""
//            let refreshToken = userDefaults.string(forKey: "refreshToken") ?? ""
//            let expiresIn = userDefaults.integer(forKey: "expiresIn")
//            let password = userDefaults.string(forKey: "Password") ?? ""
//            let username = userDefaults.string(forKey: "Username") ?? ""
//            
//            let currentUser: [String: Any] = [
//                "accessToken": accessToken,
//                "refreshToken": refreshToken,
//                "expiresIn": expiresIn,
//                "requestingPartyToken": "Bearer",
//                "message": "success",
//                "isPasswordChange": false,
//                "username": username
//            ]
//            
//            let vendorType = userDefaults.string(forKey: "IsSubVendor") ?? "0"
//            
//            // Get cwaDetails from payload
//            guard let cwaDetails:[String:Any]? = parent.payload.cwaDetails else {
//                print("❌ No cwaDetails in payload")
//                return ""
//            }
//            
//            // Convert to JSON strings
//            guard let cwaDetailsData = try? JSONSerialization.data(withJSONObject: cwaDetails, options: []),
//                  let cwaDetailsJson = String(data: cwaDetailsData, encoding: .utf8),
//                  let currentUserData = try? JSONSerialization.data(withJSONObject: currentUser, options: []),
//                  let currentUserJson = String(data: currentUserData, encoding: .utf8) else {
//                print("❌ Failed to serialize JSON")
//                return ""
//            }
//            
//            // Check if candidateData/candidateInfo need parsing
//            // If they're already JSON strings (check for leading "{"), use them directly
//            // Otherwise they might need to be unescaped first
//            let candidateDataClean = cleanJSONString(parent.candidateData)
//            let candidateInfoClean = cleanJSONString(parent.candidateInfo)
//            
//            print("📋 CWA Details JSON: \(cwaDetailsJson)")
//            print("📋 Current User JSON: \(currentUserJson)")
//            print("📋 Candidate Data: \(candidateDataClean)")
//            print("📋 Candidate Info: \(candidateInfoClean)")
//            
//            // Escape for JavaScript - use a more robust escaping method
//            let escapedCwaDetails = escapeForJavaScript(cwaDetailsJson)
//            let escapedCurrentUser = escapeForJavaScript(currentUserJson)
//            let escapedCandidateData = escapeForJavaScript(candidateDataClean)
//            let escapedCandidateInfo = escapeForJavaScript(candidateInfoClean)
//            let escapedPassword = escapeForJavaScript(password)
//            let escapedUsername = escapeForJavaScript(username)
//            let escapedVendorType = escapeForJavaScript(vendorType)
//            
//            // Build the injection script
//            return """
//            (function() {
//                try {
//                    console.log("🔧 Starting data injection...");
//                    
//                    if (typeof(Storage) === "undefined") {
//                        console.error("❌ Web Storage not supported");
//                        return { success: false, error: "Storage not supported" };
//                    }
//                    
//                    // Basic flags
//                    localStorage.setItem('isHeadless', "true");
//                    localStorage.setItem('keygaurd', "\(escapedPassword)");
//                    localStorage.setItem('keyname', "\(escapedUsername)");
//                    localStorage.setItem('isSubvendor', "\(escapedVendorType)");
//                    
//                    // Store JSON objects
//                    sessionStorage.setItem('cwaDetails', "\(escapedCwaDetails)");
//                    localStorage.setItem('currentUser', "\(escapedCurrentUser)");
//                    
//                    // Store candidate data if present
//                    var candidateDataStr = "\(escapedCandidateData)";
//                    if (candidateDataStr && candidateDataStr !== "" && candidateDataStr !== "{}") {
//                        localStorage.setItem('candidateData', candidateDataStr);
//                        sessionStorage.setItem('candidateData', candidateDataStr);
//                        console.log("✅ Candidate data stored");
//                    }
//                    
//                    // Store candidate info if present
//                    var candidateInfoStr = "\(escapedCandidateInfo)";
//                    if (candidateInfoStr && candidateInfoStr !== "" && candidateInfoStr !== "{}") {
//                        sessionStorage.setItem('loggedinInfo', candidateInfoStr);
//                        localStorage.setItem('loggedinInfo', candidateInfoStr);
//                        console.log("✅ Candidate info stored");
//                    }
//                    
//                    console.log("✅ Injection complete");
//                    console.log("Stored items:", {
//                        currentUser: !!localStorage.getItem('currentUser'),
//                        cwaDetails: !!sessionStorage.getItem('cwaDetails'),
//                        keygaurd: !!localStorage.getItem('keygaurd'),
//                        keyname: !!localStorage.getItem('keyname')
//                    });
//                    
//                    // Dispatch custom event
//                    window.dispatchEvent(new CustomEvent('dataInjectionComplete', { 
//                        detail: { success: true, timestamp: Date.now() } 
//                    }));
//                    
//                    return { success: true };
//                } catch (e) {
//                    console.error("❌ Injection error:", e.message);
//                    console.error("Stack:", e.stack);
//                    return { success: false, error: e.message };
//                }
//            })();
//            """
//        }
//
//        // Helper to clean JSON strings that might be double-escaped
//        private func cleanJSONString(_ jsonString: String) -> String {
//            let trimmed = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
//            
//            // If empty or already a simple object, return as-is
//            if trimmed.isEmpty || trimmed == "{}" {
//                return trimmed
//            }
//            
//            // Check if it's a stringified JSON string (starts with escaped quote)
//            if trimmed.hasPrefix("\\\"") || trimmed.hasPrefix("\"{") {
//                // Try to parse it as a JSON string to get the actual JSON
//                if let data = trimmed.data(using: .utf8),
//                   let unescaped = try? JSONSerialization.jsonObject(with: data) as? String {
//                    return unescaped
//                }
//            }
//            
//            return trimmed
//        }
//
//        // IMPROVED escapeForJavaScript function
//        private func escapeForJavaScript(_ string: String) -> String {
//            var escaped = string
//            
//            // Escape in this specific order
//            escaped = escaped.replacingOccurrences(of: "\\", with: "\\\\")  // Backslashes first
//            escaped = escaped.replacingOccurrences(of: "\"", with: "\\\"")  // Double quotes
//            escaped = escaped.replacingOccurrences(of: "'", with: "\\'")    // Single quotes
//            escaped = escaped.replacingOccurrences(of: "\n", with: "\\n")   // Newlines
//            escaped = escaped.replacingOccurrences(of: "\r", with: "\\r")   // Carriage returns
//            escaped = escaped.replacingOccurrences(of: "\t", with: "\\t")   // Tabs
//            escaped = escaped.replacingOccurrences(of: "`", with: "\\`")    // Backticks
//            
//            return escaped
//        }
//
//        // Helper to convert dictionary to JSON string
//        private func toJSONString(_ dict: [String: Any]) -> String {
//            guard let data = try? JSONSerialization.data(withJSONObject: dict),
//                  let string = String(data: data, encoding: .utf8) else {
//                return "{}"
//            }
//            return string
//        }
//
//
//        private func verifyInjection(_ webView: WKWebView) {
//            let verificationScript = """
//            (function() {
//                try {
//                    var currentUser = localStorage.getItem('currentUser');
//                    var cwaDetails = sessionStorage.getItem('cwaDetails');
//                    
//                    console.log("📦 Raw currentUser:", currentUser);
//                    console.log("📦 Raw cwaDetails:", cwaDetails);
//                    
//                    // Try to parse them
//                    try {
//                        var parsedUser = JSON.parse(currentUser);
//                        console.log("✅ Parsed currentUser:", parsedUser);
//                    } catch (e) {
//                        console.error("❌ Failed to parse currentUser:", e.message);
//                    }
//                    
//                    try {
//                        var parsedCwa = JSON.parse(cwaDetails);
//                        console.log("✅ Parsed cwaDetails:", parsedCwa);
//                    } catch (e) {
//                        console.error("❌ Failed to parse cwaDetails:", e.message);
//                    }
//                    
//                    return { success: true };
//                } catch (err) {
//                    console.error("❌ Verification error:", err.message);
//                    return { error: err.message };
//                }
//            })();
//            """
//            
//            webView.evaluateJavaScript(verificationScript) { result, error in
//                if let error = error {
//                    print("❌ Verification error: \(error.localizedDescription)")
//                } else {
//                    print("✅ Verification completed")
//                }
//            }
//        }
//
//        // MARK: - Message handler from page -> native
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            guard message.name == "debugHandler" else { return }
//
//            // message.body can be a dictionary from JS
//            if let body = message.body as? [String: Any], let type = body["type"] as? String {
//                print("📨 JS Message (\(type)): \(body)")
//
//                switch type {
//                case "injection_success":
//                    print("🎉 JavaScript reported injection success at \(body["timestamp"] ?? "")")
//                case "injection_error":
//                    print("💥 JavaScript reported injection error: \(body["message"] ?? "unknown")")
//                    if let stack = body["stack"] {
//                        print("   stack: \(stack)")
//                    }
//                case "verification_result":
//                    print("📊 Verification result: \(String(describing: body["results"]))")
//                case "verification_error":
//                    print("❌ Verification error: \(body)")
//                default:
//                    print("ℹ️ Unknown message type from JS: \(type)")
//                }
//            } else {
//                // For non-dictionary messages, print raw body
//                print("📨 JS Message (raw): \(message.body)")
//            }
//        }
//
//
//        /// Escape a string for safe insertion inside a single-quoted JS string literal.
//        /// We use single quotes in JS and escape: backslash, single-quote, newline, carriage return, and tab.
//        private func escapeForJSSingleQuotedString(_ string: String) -> String {
//            return string
//                .replacingOccurrences(of: "\\", with: "\\\\")
//                .replacingOccurrences(of: "'", with: "\\'")
//                .replacingOccurrences(of: "\n", with: "\\n")
//                .replacingOccurrences(of: "\r", with: "\\r")
//                .replacingOccurrences(of: "\t", with: "\\t")
//        }
//    }
//}
//
//import SwiftUI
//import WebKit
//
//// Assuming WebViewPayload is defined elsewhere in your project
//// struct WebViewPayload: Decodable {
////     let cwaDetails: [String: Any]?
////     // ... other properties
//// }
//
//struct WebView: UIViewRepresentable {
//    let url: URL
//    @Binding var isLoading: Bool
//    let payload: WebViewPayload // Requires definition
//    let candidateData: String
//    let candidateInfo: String
//    let currentUserJson: String
//    let keyGuard: String
//    let keyName: String
//    let accessToken: String
//    let isHeadless: Bool
//    var onTitleChange: ((String) -> Void)?
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
////    func makeUIView(context: Context) -> WKWebView {
////        let preferences = WKWebpagePreferences()
////        preferences.allowsContentJavaScript = true
////        preferences.allowsContentJavaScript = true
////        preferences.preferredContentMode = .mobile  // faster layout for mobile
////
////        let config = WKWebViewConfiguration()
////        config.defaultWebpagePreferences = preferences
////        config.websiteDataStore = .nonPersistent() // faster, avoids disk I/O
////        config.suppressesIncrementalRendering = false // render content ASAP
////        config.allowsInlineMediaPlayback = true
////
////        // Message handlers
////        config.userContentController.add(context.coordinator, name: "debugHandler")
////        config.userContentController.add(context.coordinator, name: "printHandler")
////
////        let webView = WKWebView(frame: .zero, configuration: config)
////        webView.navigationDelegate = context.coordinator
////        webView.allowsBackForwardNavigationGestures = false
////        webView.scrollView.isScrollEnabled = true
////        webView.isOpaque = false
////        webView.backgroundColor = .clear
////        return webView
////    }
//
////    func makeUIView(context: Context) -> WKWebView {
////        let preferences = WKWebpagePreferences()
////        preferences.allowsContentJavaScript = true
////        preferences.preferredContentMode = .mobile
////
////        let config = WKWebViewConfiguration()
////        config.defaultWebpagePreferences = preferences
////        
////        // ✅ CRITICAL: Use default (persistent) data store instead of nonPersistent
////        // nonPersistent may cause SSL/certificate issues
////        config.websiteDataStore = .default()
////        
////        config.suppressesIncrementalRendering = false
////        config.allowsInlineMediaPlayback = true
////        
////        // ✅ Enable legacy TLS if your server uses older protocols
////        if #available(iOS 14.0, *) {
////            config.limitsNavigationsToAppBoundDomains = false
////        }
////        
////        
////
////        // Message handlers
////        config.userContentController.add(context.coordinator, name: "debugHandler")
////        config.userContentController.add(context.coordinator, name: "printHandler")
////
////        let webView = WKWebView(frame: .zero, configuration: config)
////        webView.navigationDelegate = context.coordinator
////        webView.allowsBackForwardNavigationGestures = false
////        webView.scrollView.isScrollEnabled = true
////        // Set User-Agent to match a standard browser
////            webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
////        // ✅ CRITICAL: Handle SSL certificate challenges
////        webView.navigationDelegate = context.coordinator
////        
////        return webView
////    }
//    
//    // In struct WebView: UIViewRepresentable
//    // In struct WebView: UIViewRepresentable
//
//    func makeUIView(context: Context) -> WKWebView {
//        // ... (unchanged setup) ...
//        let preferences = WKWebpagePreferences()
//                preferences.allowsContentJavaScript = true
//                preferences.preferredContentMode = .mobile
//        
//                let config = WKWebViewConfiguration()
//                config.defaultWebpagePreferences = preferences
//        // 1. Generate the injection script source
//        let injectionScriptSource = context.coordinator.createInjectionScript()
//        
//        // 2. Create the WKUserScript object
//        let userScript = WKUserScript(
//            source: injectionScriptSource,
//            injectionTime: .atDocumentStart,
//            forMainFrameOnly: true
//        )
//        
//        // 3. 🟢 CORRECT WAY: Use the explicit addUserScript method for clarity and safety
//        // Replace: config.userContentController.add(userScript)
//        config.userContentController.addUserScript(userScript)
//        
//        // Message handlers (keep these as they are correct)
//        config.userContentController.add(context.coordinator, name: "debugHandler")
//        config.userContentController.add(context.coordinator, name: "printHandler")
//
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.navigationDelegate = context.coordinator
//        // ...
//        
//        return webView
//    }
//    
//
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        if uiView.url != url {
//            print("🔄 Loading WebView URL: \(url.absoluteString)")
//            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
//            uiView.load(request)
//        }
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
//        var parent: WebView
//        private var injectionAttempts = 0
//        private let maxAttempts = 3
//
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//        
//        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//            // Inject JS ASAP, as content starts arriving
//            injectDataWithRetry(webView)
//        }
//
//        // Add this delegate method to handle SSL challenges
//        func webView(_ webView: WKWebView,
//                     didReceive challenge: URLAuthenticationChallenge,
//                     completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//            
//            print("🔐 SSL Challenge received for: \(challenge.protectionSpace.host)")
//            
//            // For development/testing with self-signed certificates
//            // REMOVE THIS IN PRODUCTION or implement proper certificate validation
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                if let serverTrust = challenge.protectionSpace.serverTrust {
//                    let credential = URLCredential(trust: serverTrust)
//                    print("✅ Accepting server trust for: \(challenge.protectionSpace.host)")
//                    completionHandler(.useCredential, credential)
//                    return
//                }
//            }
//            
//            completionHandler(.performDefaultHandling, nil)
//        }
//        
//
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            DispatchQueue.main.async { self.parent.isLoading = true }
//            injectionAttempts = 0
//            print("🚀 Navigation started: \(webView.url?.absoluteString ?? "unknown")")
//            
//            // Clear storage before load starts
//            let clearScript = "localStorage.clear(); sessionStorage.clear();";
//            webView.evaluateJavaScript(clearScript);
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.isLoading = false
//            print("✅ Navigation finished: \(webView.url?.absoluteString ?? "unknown")")
//            
//            // Install storage monitor BEFORE verifying injection
//            let storageMonitor = """
//            (function() {
//                var originalClear = Storage.prototype.clear;
//                var originalRemoveItem = Storage.prototype.removeItem;
//                var originalSetItem = Storage.prototype.setItem;
//                
//                Storage.prototype.clear = function() {
//                    console.warn("⚠️ STORAGE CLEARED by page JavaScript!");
//                    console.trace();
//                    return originalClear.call(this);
//                };
//                
//                Storage.prototype.removeItem = function(key) {
//                    if (key === 'cwaDetails' || key === 'currentUser') {
//                        console.warn("⚠️ Page tried to remove:", key);
//                        console.trace();
//                    }
//                    return originalRemoveItem.call(this, key);
//                };
//                
//                Storage.prototype.setItem = function(key, value) {
//                    if (key === 'cwaDetails' || key === 'currentUser') {
//                        console.log("📝 Page set:", key, "to:", value ? value.substring(0, 50) + "..." : "null");
//                    }
//                    return originalSetItem.call(this, key, value);
//                };
//                
//                console.log("🛡️ Storage monitoring installed");
//            })();
//            """
//            
//            webView.evaluateJavaScript(storageMonitor, completionHandler: nil)
//            
//            // Now verify
//            verifyInjection(webView)
//            addPrintOverride(webView)
//        }
//        
//        func webView(_ webView: WKWebView,
//                     didFailProvisionalNavigation navigation: WKNavigation!,
//                     withError error: Error) {
//            parent.isLoading = false
//            print("❌ Provisional navigation failed: \(error.localizedDescription)")
//            print("❌ Error details: \(error)")
//        }
//
//        func webView(_ webView: WKWebView,
//                     didFail navigation: WKNavigation!,
//                     withError error: Error) {
//            DispatchQueue.main.async { self.parent.isLoading = false }
//            print("❌ Navigation failed: \(error.localizedDescription)")
//            print("❌ Error details: \(error)")
//        }
//
//        // Add this to catch resource loading errors
//        func webView(_ webView: WKWebView,
//                     decidePolicyFor navigationResponse: WKNavigationResponse,
//                     decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//            
//            if let httpResponse = navigationResponse.response as? HTTPURLResponse {
//                print("📥 Response for: \(httpResponse.url?.absoluteString ?? "unknown")")
//                print("   Status: \(httpResponse.statusCode)")
//                
//                if httpResponse.statusCode >= 400 {
//                    print("⚠️ HTTP Error \(httpResponse.statusCode)")
//                }
//            }
//            
//            decisionHandler(.allow)
//        }
//
//        
//
//        // MARK: - Injection with retry
//        private func injectDataWithRetry(_ webView: WKWebView) {
//            guard injectionAttempts < maxAttempts else {
//                print("❌ Max injection attempts reached")
//                return
//            }
//
//            injectionAttempts += 1
//            print("🔄 Injection attempt \(injectionAttempts)/\(maxAttempts)")
//
//            let script = createInjectionScript()
//
//            webView.evaluateJavaScript(script) { result, error in
//                if let error = error {
//                    print("❌ Injection failed (attempt \(self.injectionAttempts)): \(error.localizedDescription)")
//                    // Retry after 1 second if injection fails (common WKWebView practice)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.injectDataWithRetry(webView)
//                    }
//                } else {
//                    print("✅ Data injection JS executed (attempt \(self.injectionAttempts))")
//                    self.verifyInjection(webView)
//                    self.addPrintOverride(webView)
//                }
//            }
//        }
//        
//        private func addPrintOverride(_ webView: WKWebView) {
//            let printOverrideScript = """
//                (function() {
//                    console.log("🔧 Overriding window.print...");
//                    window.print = function() {
//                        if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.printHandler) {
//                            window.webkit.messageHandlers.printHandler.postMessage('printPage');
//                            console.log("✅ Native print triggered via printHandler.");
//                        } else {
//                            console.warn("⚠️ Native print handler not available.");
//                        }
//                    };
//                })();
//                """
//            webView.evaluateJavaScript(printOverrideScript, completionHandler: nil)
//        }
//
//
//        // MARK: - Build injection script (UPDATED TO USE SINGLE QUOTES)
//        public func mapCwaDetailsKeys(_ cwaDetails: [String: Any]) -> [String: Any] {
//            // Map from cma-prefixed keys to the correct keys
//            let keyMapping: [String: String] = [
//                "cmaClientContactInfoId": "ClientContactInfoId",
//                "cmaClientId": "ClientId",
//                "cmaClientName": "ClientName",
//                "cmaContactId": "ContactId",
//                "cmaDivisionId": "DivisionID",
//                "cmaDivisionName": "DivisionName",
//                "cmaMaster": "Master",
//                "cmaName": "displayName"
//            ]
//            
//            var mappedDetails: [String: Any] = [:]
//            
//            for (oldKey, value) in cwaDetails {
//                if let newKey = keyMapping[oldKey] {
//                    mappedDetails[newKey] = value
//                } else {
//                    // Keep unmapped keys as-is
//                    mappedDetails[oldKey] = value
//                }
//            }
//            
//            // Add siteName with the same value as ClientName
//            if let clientName = mappedDetails["ClientName"] {
//                mappedDetails["siteName"] = clientName
//            }
//            
//            return mappedDetails
//        }
//
//        public func createInjectionScript() -> String {
//            let userDefaults = UserDefaults.standard
//            
//            let accessToken = userDefaults.string(forKey: "accessToken") ?? parent.accessToken
//            let refreshToken = userDefaults.string(forKey: "refreshToken") ?? ""
//            let expiresIn = userDefaults.integer(forKey: "expiresIn")
//            let password = userDefaults.string(forKey: "Password") ?? parent.keyGuard
//            let username = userDefaults.string(forKey: "Username") ?? parent.keyName
//            let vendorType = userDefaults.string(forKey: "IsSubVendor") ?? "0"
//            
//            // Build currentUser object
//            let currentUser: [String: Any] = [
//                "accessToken": accessToken,
//                "refreshToken": refreshToken,
//                "expiresIn": expiresIn,
//                "requestingPartyToken": "Bearer",
//                "message": "success",
//                "isPasswordChange": false,
//                "username": username
//            ]
//            
//            // Get cwaDetails from payload
//            let newValues = mapCwaDetailsKeys(parent.payload.cwaDetails)
//               guard let originalCwaDetails:[String:Any]? = newValues else {
//                print("❌ No cwaDetails in payload")
//                return ""
//            }
//            
//            // Map the keys to the correct format (call mapping only once)
//            let cwaDetails = mapCwaDetailsKeys(originalCwaDetails ?? [:])
//            print("✅ Mapped cwaDetails: \(cwaDetails)")
//            
//            // Convert to JSON strings
//            guard let cwaDetailsJson = toJSONString(cwaDetails),
//                  let currentUserJson = toJSONString(currentUser) else {
//                print("❌ Failed to serialize JSON")
//                return ""
//            }
//            
//            // Clean and prepare candidate data
//            let candidateDataClean = cleanJSONString(parent.candidateData)
//            let candidateInfoClean = cleanJSONString(parent.candidateInfo)
//            
//            // Escape for JavaScript using single-quote safe escaping
//            let escapedCwaDetails = escapeForJavaScript(cwaDetailsJson)
//            let escapedCurrentUser = escapeForJavaScript(currentUserJson)
//            let escapedCandidateData = escapeForJavaScript(candidateDataClean)
//            let escapedCandidateInfo = escapeForJavaScript(candidateInfoClean)
//            let escapedPassword = escapeForJavaScript(password)
//            let escapedUsername = escapeForJavaScript(username)
//            let escapedVendorType = escapeForJavaScript(vendorType)
//            
//            print("✅ cwaDetails in \(escapedCwaDetails)")
//            print("✅ current user in \(escapedCurrentUser)")
//            print("✅ cwapassword in \(escapedPassword)")
//            print("✅ cwausername in \(escapedUsername)")
//            print("✅ cwavendortype in \(escapedVendorType)")
//           
//            
//            // Build injection script using single quotes (') to wrap the string values
//                
//                return """
//                (function() {
//                    try {
//                        console.log("🔧 Starting data injection...");
//                        
//                        // Store all data first
//                        localStorage.setItem('isHeadless', 'true');
//                        localStorage.setItem('keygaurd', '\(escapedPassword)');
//                        localStorage.setItem('keyname', '\(escapedUsername)');
//                        localStorage.setItem('isSubvendor', '\(escapedVendorType)');
//                        sessionStorage.setItem('cwaDetails', '\(escapedCwaDetails)');
//                        localStorage.setItem('currentUser', '\(escapedCurrentUser)');
//                        
//                        // Candidate data...
//                        var candidateDataStr = '\(escapedCandidateData)';
//                        if (candidateDataStr && candidateDataStr !== "" && candidateDataStr !== "{}") {
//                            localStorage.setItem('candidateData', candidateDataStr);
//                            sessionStorage.setItem('candidateData', candidateDataStr);
//                        }
//                        
//                        var candidateInfoStr = '\(escapedCandidateInfo)';
//                        if (candidateInfoStr && candidateInfoStr !== "" && candidateInfoStr !== "{}") {
//                            sessionStorage.setItem('loggedinInfo', candidateInfoStr);
//                            localStorage.setItem('loggedinInfo', candidateInfoStr);
//                        }
//                        
//                        console.log("✅ Injection complete");
//                        
//                        // NEW: Dispatch event AFTER a brief delay to ensure page scripts are loaded
//                        setTimeout(function() {
//                            window.dispatchEvent(new Event('storage'));
//                            window.dispatchEvent(new CustomEvent('dataInjectionComplete', { 
//                                detail: { success: true, timestamp: Date.now() } 
//                            }));
//                            
//                            // Force a page refresh of storage-dependent components
//                            if (window.location.reload) {
//                                console.log("🔄 Triggering page refresh...");
//                                // Don't actually reload, just trigger any listeners
//                            }
//                        }, 100);
//                        
//                        // ... rest of your code
//                    } catch (e) {
//                        console.error("❌ Injection error:", e.message);
//                    }
//                })();
//                """
//            
//        }
//
//        // MARK: - Helper functions
//
//        // MARK: UPDATED: Escape single quotes to prevent breaking the JS string literal
//        private func escapeForJavaScript(_ string: String) -> String {
//            var escaped = string
//            // 1. Escape backslashes first
//            escaped = escaped.replacingOccurrences(of: "\\", with: "\\\\")
//            
//            // 2. Escape single quotes, as we use them to wrap the values in the JS code
//            escaped = escaped.replacingOccurrences(of: "'", with: "\\'")
//            
//            // 3. Escape newlines, carriage returns, and tabs
//            escaped = escaped.replacingOccurrences(of: "\n", with: "\\n")
//            escaped = escaped.replacingOccurrences(of: "\r", with: "\\r")
//            escaped = escaped.replacingOccurrences(of: "\t", with: "\\t")
//            
//            // Backtick (`) and dollar sign ($) escaping are removed since we are no longer using template literals
//            return escaped
//        }
//        
//        private func cleanJSONString(_ jsonString: String) -> String {
//            let trimmed = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
//            
//            if trimmed.isEmpty || trimmed == "{}" {
//                return trimmed
//            }
//            
//            // Check if it's double-escaped JSON
//            if trimmed.hasPrefix("\\\"") || trimmed.hasPrefix("\"{") {
//                if let data = trimmed.data(using: .utf8),
//                   let unescaped = try? JSONSerialization.jsonObject(with: data) as? String {
//                    return unescaped
//                }
//            }
//            
//            return trimmed
//        }
//
//        private func toJSONString(_ dict: [String: Any]) -> String? {
//            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
//                  let string = String(data: data, encoding: .utf8) else {
//                return nil
//            }
//            return string
//        }
//
//        private func verifyInjection(_ webView: WKWebView) {
//            let enhancedDiagnosticScript = """
//            (function() {
//                try {
//                    console.log("=== ENHANCED DIAGNOSTIC ===");
//                    
//                    // Check storage
//                    var cwaFromSession = sessionStorage.getItem('cwaDetails');
//                    var currentUserFromLocal = localStorage.getItem('currentUser');
//                    var parsedCwa = null;
//                    var parsedUser = null;
//                    
//                    try {
//                        parsedCwa = JSON.parse(cwaFromSession);
//                        parsedUser = JSON.parse(currentUserFromLocal);
//                    } catch(e) {
//                        console.error("Parse error:", e);
//                    }
//                    
//                    console.log("✅ Storage check:", {
//                        hasCwaDetails: !!cwaFromSession,
//                        hasCurrentUser: !!currentUserFromLocal,
//                        cwaClientId: parsedCwa?.ClientId,
//                        userAccessToken: parsedUser?.accessToken ? "present" : "missing"
//                    });
//                    
//                    // Check if page has Angular/React context
//                    console.log("📦 Framework check:", {
//                        hasAngular: typeof angular !== 'undefined',
//                        hasReact: typeof React !== 'undefined',
//                        hasVue: typeof Vue !== 'undefined',
//                        hasJQuery: typeof jQuery !== 'undefined' || typeof $ !== 'undefined'
//                    });
//                    
//                    // Check DOM state
//                    console.log("📄 DOM state:", {
//                        readyState: document.readyState,
//                        bodyChildren: document.body ? document.body.children.length : 0,
//                        hasGroupTimeApproval: !!document.querySelector('[class*="group"]') || !!document.querySelector('[class*="time"]') || !!document.querySelector('[class*="approval"]'),
//                        visibleElements: document.querySelectorAll('*:not([hidden]):not([style*="display: none"])').length
//                    });
//                    
//                    // Try to find the app root
//                    var appRoot = document.getElementById('app') || 
//                                 document.getElementById('root') || 
//                                 document.querySelector('[ng-app]') ||
//                                 document.querySelector('[data-reactroot]');
//                    console.log("🌳 App root found:", !!appRoot);
//                    
//                    // Check for any error messages in the DOM
//                    var errorElements = Array.from(document.querySelectorAll('*')).filter(el => 
//                        el.textContent.toLowerCase().includes('error') || 
//                        el.textContent.toLowerCase().includes('unauthorized') ||
//                        el.textContent.toLowerCase().includes('loading')
//                    );
//                    console.log("⚠️ Potential error messages:", errorElements.length > 0 ? errorElements.map(el => el.textContent.substring(0, 50)) : "none");
//                    
//                    // Listen for storage changes
//                    window.addEventListener('storage', function(e) {
//                        console.log("🔄 Storage changed:", e.key, "New value:", e.newValue ? e.newValue.substring(0, 50) + "..." : "null");
//                    });
//                    
//                    // Check if page JavaScript is accessing our injected data
//                    var originalGetItem = Storage.prototype.getItem;
//                    Storage.prototype.getItem = function(key) {
//                        var value = originalGetItem.call(this, key);
//                        if (key === 'cwaDetails' || key === 'currentUser') {
//                            console.log("📖 Page read from storage:", key, value ? "✅ found" : "❌ null");
//                        }
//                        return value;
//                    };
//                    
//                    return {
//                        hasData: !!cwaFromSession,
//                        canParse: !!parsedCwa,
//                        sampleProperty: parsedCwa?.ClientId,
//                        domReady: document.readyState === 'complete',
//                        bodyHasContent: document.body ? document.body.children.length > 0 : false,
//                        appRootFound: !!appRoot
//                    };
//                } catch (err) {
//                    console.error("❌ Diagnostic error:", err);
//                    return { error: err.message };
//                }
//            })();
//            """
//            
//            webView.evaluateJavaScript(enhancedDiagnosticScript) { result, error in
//                if let result = result {
//                    print("🔍 ENHANCED DIAGNOSTIC: \(result)")
//                }
//            }
//            
//            // Also check after 2 seconds to see if page eventually loads
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                webView.evaluateJavaScript("document.body ? document.body.children.length : 0") { count, _ in
//                    print("🕐 DOM elements after 2s: \(count ?? 0)")
//                }
//                
//                webView.evaluateJavaScript("sessionStorage.getItem('cwaDetails') ? 'still present' : 'gone'") { result, _ in
//                    print("🕐 cwaDetails after 2s: \(result ?? "unknown")")
//                }
//            }
//        }
//
//        // MARK: - Message handler from JavaScript
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            if message.name == "debugHandler" {
//                if let body = message.body as? [String: Any], let type = body["type"] as? String {
//                    print("📨 JS Message (\(type)): \(body)")
//
//                    switch type {
//                    case "injection_success":
//                        print("🎉 JavaScript reported injection success at \(body["timestamp"] ?? "")")
//                    case "injection_error":
//                        print("💥 JavaScript reported injection error: \(body["message"] ?? "unknown")")
//                        if let stack = body["stack"] {
//                            print("   stack: \(stack)")
//                        }
//                    case "verification_result":
//                        print("📊 Verification result: \(body["results"] ?? [:])")
//                    case "verification_error":
//                        print("❌ Verification error: \(body)")
//                    default:
//                        print("ℹ️ Unknown message type from JS: \(type)")
//                    }
//                } else {
//                    print("📨 JS Message (raw): \(message.body)")
//                }
//            } else if message.name == "printHandler" {
//                if let command = message.body as? String, command == "printPage" {
//                    print("🖨️ NATIVE COMMAND RECEIVED: printPage(). Implement your SwiftUI/UIKit printing logic here.")
//                    // TODO: Implement actual native printing logic using UIPrintInteractionController or similar.
//                }
//            }
//        }
//    }
//}
import SwiftUI
import WebKit
import Combine

// MARK: - Lightweight AnyCodable
struct AnyCodable: Codable {
    let value: Any
    init(_ value: Any) { self.value = value }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(Int.self) { value = int; return }
        if let double = try? container.decode(Double.self) { value = double; return }
        if let bool = try? container.decode(Bool.self) { value = bool; return }
        if let str = try? container.decode(String.self) { value = str; return }
        if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }; return
        }
        if let arr = try? container.decode([AnyCodable].self) {
            value = arr.map { $0.value }; return
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let int as Int: try container.encode(int)
        case let dbl as Double: try container.encode(dbl)
        case let bool as Bool: try container.encode(bool)
        case let str as String: try container.encode(str)
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { AnyCodable($0) })
        case let arr as [Any]:
            try container.encode(arr.map { AnyCodable($0) })
        default:
            try container.encode(String(describing: value))
        }
    }
}

// MARK: - Payload Model
struct CWAData: Codable {
    let cwaDetails: [String: AnyCodable]?
    let currentUser: [String: AnyCodable]?
    let cwaCredentials: [String: AnyCodable]?
}

// MARK: - WebView
struct CWAWebView: UIViewRepresentable {
    let url: URL
    var jsMessage: [String: Any]? = nil
    var webViewStorage: [String: Any]? = nil
    @Binding var isLoading: Bool
    @Binding var loadTime: TimeInterval
    var onMessage: ((Any) -> Void)? = nil
    var injectAtDocumentStart: Bool = false
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, onMessage: onMessage, isLoading: $isLoading, loadTime: $loadTime)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        print("🌐 makeUIView() - creating WKWebView for URL: \(url.absoluteString)")
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.websiteDataStore = .default()
        config.userContentController.add(context.coordinator, name: Coordinator.messageHandlerName)
        
        // Inject JS payload
        let merged = mergedPayload(from: jsMessage ?? [:], and: webViewStorage ?? [:])
        let js = buildInjectionScript(from: merged)
        let injectionTime: WKUserScriptInjectionTime = injectAtDocumentStart ? .atDocumentStart : .atDocumentEnd
        let userScript = WKUserScript(source: js, injectionTime: injectionTime, forMainFrameOnly: true)
        config.userContentController.addUserScript(userScript)
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        print("🌍 Loading URL request: \(url)")
        DispatchQueue.main.async { self.isLoading = true }
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    // MARK: - Helper
    private func mergedPayload(from jsMessage: [String: Any], and webViewStorage: [String: Any]) -> [String: Any] {
        return ["jsMessage": jsMessage, "storage": webViewStorage]
    }
    
    private func buildInjectionScript(from merged: [String: Any]) -> String {
        return "console.log('✅ JS injected with payload:', \(merged));"
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        static let messageHandlerName = "cwaData"
        private var onMessage: ((Any) -> Void)?
        private var isLoading: Binding<Bool>?
        private var loadTime: Binding<TimeInterval>?
        private var parent: CWAWebView
        private var startTime: CFAbsoluteTime?
        
        init(parent: CWAWebView, onMessage: ((Any) -> Void)?, isLoading: Binding<Bool>?, loadTime: Binding<TimeInterval>?) {
            self.parent = parent
            self.onMessage = onMessage
            self.isLoading = isLoading
            self.loadTime = loadTime
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("📨 JS message received: \(message.body)")
            DispatchQueue.main.async { self.onMessage?(message.body) }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            startTime = CFAbsoluteTimeGetCurrent()
            DispatchQueue.main.async { self.isLoading?.wrappedValue = true }
            print("⏳ [\(self.parent.url.absoluteString)] Start loading at \(Date())")
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let start = startTime else {
                print("⚠️ No startTime recorded — cannot calculate loadTime")
                return
            }
            let elapsed = CFAbsoluteTimeGetCurrent() - start
            DispatchQueue.main.async {
                self.isLoading?.wrappedValue = false
                self.loadTime?.wrappedValue = elapsed
            }
            print("✅ [\(self.parent.url.absoluteString)] Finished loading in \(String(format: "%.2f", elapsed)) sec")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ didFail navigation: \(error.localizedDescription)")
            DispatchQueue.main.async { self.isLoading?.wrappedValue = false }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("❌ didFailProvisionalNavigation: \(error.localizedDescription)")
            DispatchQueue.main.async { self.isLoading?.wrappedValue = false }
        }
    }
}
