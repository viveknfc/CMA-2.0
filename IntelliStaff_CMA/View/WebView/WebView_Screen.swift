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
    
//    var body: some View {
//        let base = APIConstants.UATURL
//        let support = "CWA2UAT"
//        let combined = "\(base)\(support)/\(cleanedURLKey)"
//        
//        print("the combined url is \(combined)")
//        ZStack {
//            // WebView(url: fullURL, isLoading: $isLoading, division: division, payload: buildWebViewPayload())
////            WebView(url: fullURL, isLoading: $isLoading, payload: payload, candidateData: DashboardViewModel.escapedCandidateJSONString ?? "", candidateInfo: DashboardViewModel.escapedDemographicsJSONString ?? "",currentUserJson: payload.currentUserJson, keyGuard: payload.keyGuard,     keyName: payload.keyName,
////                    accessToken: payload.accessToken,
////                    isHeadless: true, onTitleChange: { title in
////                pageTitle = title
////            })
////            let base = APIConstants.baseURL
////            let support = "CWA2UAT"
////            let combined = "\(base)\(support)/\(cleanedURLKey)"
////            web(
////                url: combined,
////                title: "",
////                isLoading: $isLoading,
////                candidateData: DashboardViewModel.escapedCandidateJSONString ?? "",
////                candidateInfo: DashboardViewModel.escapedDemographicsJSONString ?? ""
////            ) { title in
////                pageTitle = title  // ✅ now will update dynamically
////            }
////            .navigationTitle(pageTitle)
//            let userDefaults = UserDefaults.standard
//            let accessToken = userDefaults.string(forKey: "accessToken") ?? payload.accessToken
//                       let refreshToken = userDefaults.string(forKey: "refreshToken") ?? ""
//                       let expiresIn = userDefaults.integer(forKey: "expiresIn")
//                       let password = userDefaults.string(forKey: "Password") ?? payload.keyGuard
//                       let username = userDefaults.string(forKey: "Username") ?? payload.keyName
//                       let vendorType = userDefaults.string(forKey: "IsSubVendor") ?? "0"
//            
//            let jsMessageDict: [String: Any] = [
//                "currentUser": [
//                    "accessToken": "\(payload.accessToken)",
//                    "username": "\(payload.keyName)",
//                    "message": "success",
//                    "expiresIn": expiresIn,
//                    "isPasswordChange": false
//                ],
//                "cwaDetails": payload.cwaDetails,
//                "cwaCredentials": [
//                    "username": "\(username)",
//                    "password": "\(password)",
//                    "vendorType": vendorType
//                ]
//            ]
//
//            // Example WebView storage override (optional)
//            let webViewStorageDict: [String: Any] = [
//                "keyname": "\(username)",
//                "keygaurd": "\(password)",
//                "isSubvendor": vendorType,
//                "isHeadless": true
//            ]
//            let base = APIConstants.UATURL
//            let support = "CWA2UAT"
//            let combined = "\(base)\(support)/\(cleanedURLKey)"
//            
//            print("the combined url is \(combined)")
//            
//            CWAWebView(
//                urlString: combined,
//                jsMessage: jsMessageDict,
//                webViewStorage: webViewStorageDict,
//                onMessage: { body in
//                    print("Received from webview:", body)
//                },
//                injectAtDocumentStart: false // set true if you want to run at documentStart
//            )
//            
//            if isLoading {
//                Color.black.opacity(0.5)
//                    .ignoresSafeArea()
//                TriangleLoader()
//            }
//        }
////            WebViewScreen(url: combined, title: "")
//            //            if isLoading {
//            //                    Color.black.opacity(0.5)
//            //                        .ignoresSafeArea()
//            //                    TriangleLoader()
//            //                }
//            //            }
//            
////            WebViewScreen(
////                url: combined,
////                title: "Candidate Form",
////                candidateData: DashboardViewModel.escapedCandidateJSONString ?? "",
////                candidateInfo: DashboardViewModel.escapedDemographicsJSONString ?? "",
////                currentUserJson: payload.currentUserJson
////               
////            )
//                .onAppear {
//                    print("Full URL: \(fullURL)")
//                    print("📊 Data to inject:")
//                    print("   Candidate Data: \(DashboardViewModel.escapedCandidateJSONString ?? "")")
//                    print("   Demographics: \(DashboardViewModel.escapedDemographicsJSONString ?? "nil")")
//                    print("   Current User: \(payload.currentUserJson)")
//                }
//                .navigationTitle(pageTitle)
//                .navigationBarBackButtonHidden(true)
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//                            dismiss()
//                        }) {
//                            Image(systemName: "chevron.backward") // 👈 just the arrow
//                                .foregroundColor(.white)
//                                .imageScale(.large)
//                        }
//                    }
//                }
//                .tint(.white)
//        }
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
                injectAtDocumentStart: false
            )
            

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
        .navigationTitle(cleanedURLKey)  // << Use cleaned URL as navigation title
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
//struct WebView_Screen: View {
//    
//    var urlKey: String
//    @State private var isLoading = true
//    @Environment(\.dismiss) private var dismiss
//    @State private var pageTitle = "Loading..."
//
//    @Bindable var viewModel: DashboardViewModel
//    let payload = buildWebViewPayload()
//    
//    var cleanedURLKey: String {
//        var modified = urlKey
//        if let range = modified.range(of: "&headless=true") {
//            modified.removeSubrange(range)
//        }
//        return modified
//    }
//    
//    var fullURL: URL {
//        let base = APIConstants.baseURL
//       // let support = "Cwa2dev"
//       // https://apps.tempositions.com/CWA2UAT/EditYourInformation
//        let support = "CWA2UAT"
//        let combined = "\(base)\(support)/\(cleanedURLKey)"
//        
//        print("the combined url is \(combined)")
//
//        return URL(string: combined) ?? URL(string: "https://example.com")!
//    }
//   
//
//    
//    var body: some View {
//
//        ZStack {
//            WebView(url: fullURL, isLoading: $isLoading, candidateData: DashboardViewModel.escapedCandidateJSONString ?? "", candidateInfo: DashboardViewModel.escapedDemographicsJSONString ?? "",currentUserJson: payload.currentUserJson, keyGuard: payload.keyGuard,     keyName: payload.keyName,
//                accessToken: payload.accessToken,
//                isHeadless: true, onTitleChange: { title in
//                pageTitle = title
//            })
////            WebViewScreen(url: fullURL, payload: DashboardViewModel.escapedCandidateJSONString ?? [:], isLoading: $isLoading, onTitleChange: { title in
////                pageTitle = title
////            })
//                        
//                
//            
//            if isLoading {
//                Color.black.opacity(0.5)
//                    .ignoresSafeArea()
//                TriangleLoader()
//            }
//        }
//        .onAppear {
//            print("Full URL: \(fullURL)")
//            print("📊 Data to inject:")
//            print("   Candidate Data: \(DashboardViewModel.escapedCandidateJSONString ?? [:])")
//            print("   Demographics: \(DashboardViewModel.escapedDemographicsJSONString ?? "nil")")
//                       print("   Current User: \(payload.currentUserJson)")
//        }
//        .navigationTitle(pageTitle)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "chevron.backward") // 👈 just the arrow
//                        .foregroundColor(.white)
//                        .imageScale(.large)
//                }
//            }
//        }
//        .tint(.white)
//    }
//}

//#Preview {
//    let mock = DashboardViewModel()
//    DashboardViewModel.escapedCandidateJSONString = "{\"CandidateID\":123,\"Name\":\"Preview User\"}"
//
//    return WebView_Screen(
//        urlKey: "previewKey",
//        viewModel: mock
//    )
//}



//#Preview {
//
//    WebView_Screen(urlKey: "https://www.google.com/",             division: DivisionList(
//        clientName: "Acme Corp",
//        clientID: 101,
//        contactID: 202,
//        divisionName: "Sales Division",
//        pendingTS: 3,
//        divisionId: 301,
//        showLogin: 1,
//        showBreakminutes: 0,
//        name: "John Doe",
//        master: 1,
//        clientContactInfoId: 404
//    ))
//    
//}
