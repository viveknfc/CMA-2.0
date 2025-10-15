//
//  WebView_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 24/07/25.
//

import SwiftUI

struct WebView_Screen: View {
    
    var urlKey: String
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    @State private var pageTitle = "Loading..."
    @State private var loadTime: TimeInterval = 0.0
    @Bindable var viewModel: DashboardViewModel
    let payload = buildWebViewPayload()
    
    var cleanedURLKey: String {
        var modified = urlKey
        if let range = modified.range(of: "&headless=true") {
            modified.removeSubrange(range)
        }
        return modified
    }
    
    var fullURL: URL {
        let base = APIConstants.UATURL
        let support = "CWA2UAT"
        let combined = "\(base)\(support)/\(cleanedURLKey)"
        
        print("the combined url is \(combined)")
        
        return URL(string: combined) ?? URL(string: "https://example.com")!
    }
    

    var body: some View {
        // MARK: - Prepare URL & Data
        let base = APIConstants.UATURL
        let support = "CWA2UAT"
        let combined = "\(base)\(support)/\(cleanedURLKey)"

        let userDefaults = UserDefaults.standard
        let accessToken = userDefaults.string(forKey: "accessToken") ?? payload.accessToken
        let refreshToken = userDefaults.string(forKey: "refreshToken") ?? ""
        let expiresIn = userDefaults.integer(forKey: "expiresIn")
        let password = userDefaults.string(forKey: "Password") ?? payload.keyGuard
        let username = userDefaults.string(forKey: "Username") ?? payload.keyName
        let vendorType = userDefaults.string(forKey: "IsSubVendor") ?? "0"

        let jsMessageDict: [String: Any] = [
            "currentUser": [
                "accessToken": accessToken,
                "username": username,
                "message": "success",
                "expiresIn": expiresIn,
                "isPasswordChange": false
            ],
            "cwaDetails": payload.cwaDetails,
            "cwaCredentials": [
                "username": username,
                "password": password,
                "vendorType": vendorType
            ]
        ]

        let webViewStorageDict: [String: Any] = [
            "keyname": username,
            "keygaurd": password,
            "isSubvendor": vendorType,
            "isHeadless": true
        ]

        ZStack {
            // MARK: - WebView
            CWAWebView(
                url: fullURL,
                jsMessage: jsMessageDict,
                webViewStorage: webViewStorageDict, isLoading: $isLoading, loadTime: $loadTime,
                onMessage: { body in
                    print("Received from webview:", body)
                },
                injectAtDocumentStart: false) { title in
                    pageTitle = title
                }
                
            

            // MARK: - Loader
            if isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                TriangleLoader()
            }
        }
        .onAppear {
            print("Full URL: \(combined)")
            print("📊 Data to inject:")
            print("   Candidate Data: \(DashboardViewModel.escapedCandidateJSONString ?? "")")
            print("   Demographics: \(DashboardViewModel.escapedDemographicsJSONString ?? "nil")")
            print("   Current User: \(payload.currentUserJson)")
        }
        .navigationTitle(pageTitle)  // << Use cleaned URL as navigation title
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
            }
        }
        .tint(.white)
    }


    
}
