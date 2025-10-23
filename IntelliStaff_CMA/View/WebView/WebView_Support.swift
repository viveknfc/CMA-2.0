//
//import SwiftUI
//import WebKit
//import Combine
//
//// MARK: - Lightweight AnyCodable
//struct AnyCodable: Codable {
//    let value: Any
//    init(_ value: Any) { self.value = value }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let int = try? container.decode(Int.self) { value = int; return }
//        if let double = try? container.decode(Double.self) { value = double; return }
//        if let bool = try? container.decode(Bool.self) { value = bool; return }
//        if let str = try? container.decode(String.self) { value = str; return }
//        if let dict = try? container.decode([String: AnyCodable].self) {
//            value = dict.mapValues { $0.value }; return
//        }
//        if let arr = try? container.decode([AnyCodable].self) {
//            value = arr.map { $0.value }; return
//        }
//        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
//    }
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch value {
//        case let int as Int: try container.encode(int)
//        case let dbl as Double: try container.encode(dbl)
//        case let bool as Bool: try container.encode(bool)
//        case let str as String: try container.encode(str)
//        case let dict as [String: Any]:
//            try container.encode(dict.mapValues { AnyCodable($0) })
//        case let arr as [Any]:
//            try container.encode(arr.map { AnyCodable($0) })
//        default:
//            try container.encode(String(describing: value))
//        }
//    }
//}
//
//// MARK: - Payload Model
//struct CWAData: Codable {
//    let cwaDetails: [String: AnyCodable]?
//    let currentUser: [String: AnyCodable]?
//    let cwaCredentials: [String: AnyCodable]?
//}
//
//// MARK: - WebView
//struct CWAWebView: UIViewRepresentable {
//    let url: URL
//    var jsMessage: [String: Any]? = nil
//    var webViewStorage: [String: Any]? = nil
//    @Binding var isLoading: Bool
//    @Binding var loadTime: TimeInterval
//    var onMessage: ((Any) -> Void)? = nil
//    var injectAtDocumentStart: Bool = false
//    var onTitleChange: ((String) -> Void)?
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self, onMessage: onMessage, isLoading: $isLoading, loadTime: $loadTime)
//    }
//    
//    func makeUIView(context: Context) -> WKWebView {
//        print("🌐 makeUIView() - creating WKWebView for URL: \(url.absoluteString)")
//        
//        let config = WKWebViewConfiguration()
//        config.preferences.javaScriptEnabled = true
//        config.websiteDataStore = .default()
//        config.userContentController.add(context.coordinator, name: Coordinator.messageHandlerName)
//        
//        // Inject JS payload
//        let merged = mergedPayload(from: jsMessage ?? [:], and: webViewStorage ?? [:])
//        let js = buildInjectionScript(from: merged)
//        let injectionTime: WKUserScriptInjectionTime = injectAtDocumentStart ? .atDocumentStart : .atDocumentEnd
//        let userScript = WKUserScript(source: js, injectionTime: injectionTime, forMainFrameOnly: true)
//        config.userContentController.addUserScript(userScript)
//        
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.navigationDelegate = context.coordinator
//        
//        print("🌍 Loading URL request: \(url)")
//        DispatchQueue.main.async { self.isLoading = true }
//        webView.load(URLRequest(url: url))
//        
//        return webView
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {}
//    
//    // MARK: - Helper
//    private func mergedPayload(from jsMessage: [String: Any], and webViewStorage: [String: Any]) -> [String: Any] {
//        return ["jsMessage": jsMessage, "storage": webViewStorage]
//    }
//    
//    private func buildInjectionScript(from merged: [String: Any]) -> String {
//        return "console.log('✅ JS injected with payload:', \(merged));"
//    }
//
//    // MARK: - Coordinator
//    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
//        static let messageHandlerName = "cwaData"
//        private var onMessage: ((Any) -> Void)?
//        private var isLoading: Binding<Bool>?
//        private var loadTime: Binding<TimeInterval>?
//        private var parent: CWAWebView
//        private var startTime: CFAbsoluteTime?
//        
//        init(parent: CWAWebView, onMessage: ((Any) -> Void)?, isLoading: Binding<Bool>?, loadTime: Binding<TimeInterval>?) {
//            self.parent = parent
//            self.onMessage = onMessage
//            self.isLoading = isLoading
//            self.loadTime = loadTime
//        }
//        
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            print("📨 JS message received: \(message.body)")
//            DispatchQueue.main.async { self.onMessage?(message.body) }
//        }
//        
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            startTime = CFAbsoluteTimeGetCurrent()
//            DispatchQueue.main.async { self.isLoading?.wrappedValue = true }
//            print("⏳ [\(self.parent.url.absoluteString)] Start loading at \(Date())")
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.isLoading = false
//            parent.onTitleChange?(webView.title ?? "Untitled")
//            print("✅ Page finished loading: \(webView.url?.absoluteString ?? "unknown")")
//            guard let start = startTime else {
//                print("⚠️ No startTime recorded — cannot calculate loadTime")
//                return
//            }
//            let elapsed = CFAbsoluteTimeGetCurrent() - start
//            DispatchQueue.main.async {
//                self.isLoading?.wrappedValue = false
//                self.loadTime?.wrappedValue = elapsed
//            }
//            print("✅ [\(self.parent.url.absoluteString)] Finished loading in \(String(format: "%.2f", elapsed)) sec")
//        }
//
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            print("❌ didFail navigation: \(error.localizedDescription)")
//            DispatchQueue.main.async { self.isLoading?.wrappedValue = false }
//        }
//        
//        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//            print("❌ didFailProvisionalNavigation: \(error.localizedDescription)")
//            DispatchQueue.main.async { self.isLoading?.wrappedValue = false }
//        }
//    }
//}
import SwiftUI
import WebKit
import Combine
import PDFKit

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

// MARK: - PDF Document Type
enum PDFLoadType {
    case url(URL)
    case data(Data)
    case localFile(String) // filename in bundle or documents
}

// MARK: - WebView with PDF Support
struct CWAWebView: UIViewRepresentable {
    let url: URL
    var jsMessage: [String: Any]? = nil
    var webViewStorage: [String: Any]? = nil
    @Binding var isLoading: Bool
    @Binding var loadTime: TimeInterval
    var onMessage: ((Any) -> Void)? = nil
    var injectAtDocumentStart: Bool = false
    var onTitleChange: ((String) -> Void)?
    var allowPDFDownload: Bool = true
    var pdfLoadType: PDFLoadType? = nil
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, onMessage: onMessage, isLoading: $isLoading, loadTime: $loadTime)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        print("🌐 makeUIView() - creating WKWebView for URL: \(url.absoluteString)")
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.websiteDataStore = .default()
        config.userContentController.add(context.coordinator, name: Coordinator.messageHandlerName)
        
        // Enable PDF viewing
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        // Inject JS payload
        let merged = mergedPayload(from: jsMessage ?? [:], and: webViewStorage ?? [:])
        let js = buildInjectionScript(from: merged)
        let injectionTime: WKUserScriptInjectionTime = injectAtDocumentStart ? .atDocumentStart : .atDocumentEnd
        let userScript = WKUserScript(source: js, injectionTime: injectionTime, forMainFrameOnly: true)
        config.userContentController.addUserScript(userScript)
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        // Handle different PDF load types
        if let pdfType = pdfLoadType {
            loadPDF(pdfType, into: webView)
        } else {
            print("🌍 Loading URL request: \(url)")
            DispatchQueue.main.async { self.isLoading = true }
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    // MARK: - PDF Loading Methods
    private func loadPDF(_ type: PDFLoadType, into webView: WKWebView) {
        DispatchQueue.main.async { self.isLoading = true }
        
        switch type {
        case .url(let pdfURL):
            print("📄 Loading PDF from URL: \(pdfURL.absoluteString)")
            var request = URLRequest(url: pdfURL)
            request.cachePolicy = .returnCacheDataElseLoad
            webView.load(request)
            
        case .data(let pdfData):
            print("📄 Loading PDF from Data (\(pdfData.count) bytes)")
            webView.load(pdfData, mimeType: "application/pdf", characterEncodingName: "", baseURL: url)
            
        case .localFile(let filename):
            print("📄 Loading PDF from local file: \(filename)")
            if let localURL = Bundle.main.url(forResource: filename, withExtension: nil) ?? getDocumentsURL(for: filename) {
                if let data = try? Data(contentsOf: localURL) {
                    webView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: localURL)
                } else {
                    print("❌ Failed to load PDF data from: \(localURL)")
                }
            } else {
                print("❌ PDF file not found: \(filename)")
            }
        }
    }
    
    private func getDocumentsURL(for filename: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.appendingPathComponent(filename)
    }
    
    // MARK: - Helper
    private func mergedPayload(from jsMessage: [String: Any], and webViewStorage: [String: Any]) -> [String: Any] {
        return ["jsMessage": jsMessage, "storage": webViewStorage]
    }
    
    private func buildInjectionScript(from merged: [String: Any]) -> String
    {
        let jsMessage = merged["jsMessage"] as? [String: Any] ?? [:]
        let storage = merged["storage"] as? [String: Any] ?? [:]
        
        // Helper function to convert dictionary to escaped JSON string
        func toJSONString(_ dict: [String: Any]) -> String {
            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
                  let jsonStr = String(data: data, encoding: .utf8) else {
                return "{}"
            }
            // Escape for JavaScript - must escape backslashes first, then quotes
            return jsonStr
                .replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "\"", with: "\\\"")
        }
        
        // Convert each section to JSON string
        let cwaDetailsStr = toJSONString(jsMessage["cwaDetails"] as? [String: Any] ?? [:])
        let currentUserStr = toJSONString(jsMessage["currentUser"] as? [String: Any] ?? [:])
        let cwaCredentialsStr = toJSONString(jsMessage["cwaCredentials"] as? [String: Any] ?? [:])
        
        // Get storage values
        let keyname = (storage["keyname"] as? String) ?? ""
        let keygaurd = (storage["keygaurd"] as? String) ?? ""
        let isSubvendor = storage["isSubvendor"] as? Int ?? 0
        let isHeadless = (storage["isHeadless"] as? Bool ?? false) ? "true" : "false"
        
        let pdfHelper = allowPDFDownload ? """
        window.downloadPDF = function(url, filename) {
            const a = document.createElement('a');
            a.href = url;
            a.download = filename || 'document.pdf';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        };
        document.addEventListener('click', function(e) {
            const target = e.target.closest('a');
            if (target && target.href && target.href.toLowerCase().endsWith('.pdf')) {
                window.webkit.messageHandlers.cwaData.postMessage({
                    type: 'pdfLinkClicked',
                    url: target.href,
                    filename: target.href.split('/').pop()
                });
            }
        }, true);
        """ : ""
        
        return """
        (function() {
            console.log('🚀 Starting injection...');
            
            try {
                // CRITICAL: Store in localStorage (matching Android behavior)
                localStorage.setItem('keyname', "\(keyname)");
                localStorage.setItem('keygaurd', "\(keygaurd)");
                localStorage.setItem('isSubvendor', "\(isSubvendor)");
                localStorage.setItem('isHeadless', "\(isHeadless)");
                
                // Store currentUser in localStorage (as stringified JSON)
                const currentUserData = "\(currentUserStr)";
                localStorage.setItem('currentUser', currentUserData);
                
                // Store cwaDetails in sessionStorage (as stringified JSON)
                const cwaDetailsData = "\(cwaDetailsStr)";
                sessionStorage.setItem('cwaDetails', cwaDetailsData);
                
                // Optional: Also store credentials if needed
                const cwaCredentialsData = "\(cwaCredentialsStr)";
                sessionStorage.setItem('cwaCredentials', cwaCredentialsData);
                
                // Set on window for compatibility
                window.cwaData = {
                    jsMessage: {
                        cwaDetails: JSON.parse(cwaDetailsData),
                        currentUser: JSON.parse(currentUserData),
                        cwaCredentials: JSON.parse(cwaCredentialsData)
                    },
                    storage: {
                        keyname: "\(keyname)",
                        keygaurd: "\(keygaurd)",
                        isSubvendor: \(isSubvendor),
                        isHeadless: \(isHeadless)
                    }
                };
                
                console.log('✅ Injection complete!');
                console.log('localStorage.keyname:', localStorage.getItem('keyname'));
                console.log('localStorage.currentUser:', localStorage.getItem('currentUser'));
                console.log('sessionStorage.cwaDetails:', sessionStorage.getItem('cwaDetails'));
                
            } catch (error) {
                console.error('❌ Injection failed:', error);
                console.error('Error details:', error.message, error.stack);
            }
        })();
        \(pdfHelper)
        """
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
            
            // Handle PDF-specific messages
            if let dict = message.body as? [String: Any],
               let type = dict["type"] as? String,
               type == "pdfLinkClicked" {
                print("📄 PDF link clicked: \(dict)")
            }
            
            DispatchQueue.main.async { self.onMessage?(message.body) }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            startTime = CFAbsoluteTimeGetCurrent()
            DispatchQueue.main.async { self.isLoading?.wrappedValue = true }
            print("⏳ [\(self.parent.url.absoluteString)] Start loading at \(Date())")
        }
        
        func webViewDidFinishLoad(_ webView: WKWebView) {
            webView.frame.size.height = 1
            webView.frame.size = webView.sizeThatFits(.zero)
            webView.scrollView.isScrollEnabled=false;
            webView.frame.size.height = webView.scrollView.contentSize.height
            webView.sizeThatFits(CGSize(width: webView.frame.width, height: webView.frame.height))
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            parent.onTitleChange?(webView.title ?? "Untitled")
            print("✅ Page finished loading: \(webView.url?.absoluteString ?? "unknown")")
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
        
        // MARK: - PDF Navigation Policy
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            if let mimeType = navigationResponse.response.mimeType {
                print("📋 MIME type: \(mimeType)")
                
                if mimeType == "application/pdf" {
                    print("📄 PDF detected - allowing inline display")
                    decisionHandler(.allow)
                    return
                }
            }
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                let urlString = url.absoluteString.lowercased()
                
                // Detect PDF URLs
                if urlString.hasSuffix(".pdf") || urlString.contains(".pdf?") {
                    print("📄 PDF URL detected: \(url)")
                }
            }
            decisionHandler(.allow)
        }
    }
}

