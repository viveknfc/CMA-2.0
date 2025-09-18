//
//  WebView_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 24/07/25.
//

import SwiftUI

//struct WebView_Screen: View {
//    
//    let urlKey: String
//    let division: DivisionList
//    @State private var isLoading = true
//    @Environment(\.dismiss) private var dismiss
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
//        let support = "Cwa2dev"
//        let combined = "\(base)\(support)/\(cleanedURLKey)"
//        
//        print("the combined url is \(combined)")
//
//        return URL(string: combined) ?? URL(string: "https://example.com")!
//    }
//    
//    var body: some View {
//
//        ZStack {
//            WebView(url: fullURL, isLoading: $isLoading, division: division, payload: buildWebViewPayload())
//            
//            if isLoading {
//                Color.black.opacity(0.5)
//                    .ignoresSafeArea()
//                TriangleLoader()
//            }
//        }
//        .navigationTitle("Tempositions")
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

struct WebView_Screen: View {
    
    var urlKey: String
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    @State private var pageTitle = "Loading..."

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
        let base = APIConstants.baseURL
        let support = "Cwa2dev"
        let combined = "\(base)\(support)/\(cleanedURLKey)"
        
        print("the combined url is \(combined)")

        return URL(string: combined) ?? URL(string: "https://example.com")!
    }
   

    
    var body: some View {

        ZStack {
//            WebView(url: fullURL, isLoading: $isLoading, candidateData: DashboardViewModel.escapedCandidateJSONString ?? "", candidateInfo: DashboardViewModel.escapedDemographicsJSONString ?? "",currentUserJson: payload.currentUserJson, keyGuard: payload.keyGuard,     keyName: payload.keyName,
//                accessToken: payload.accessToken,
//                isHeadless: true, onTitleChange: { title in
//                pageTitle = title
//            })
            WebViewScreen(url: fullURL, payload: DashboardViewModel.escapedCandidateJSONString ?? [:], isLoading: $isLoading)
                        
                
            
            if isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                TriangleLoader()
            }
        }
        .onAppear {
            print("Full URL: \(fullURL)")
            print("📊 Data to inject:")
            print("   Candidate Data: \(DashboardViewModel.escapedCandidateJSONString ?? [:])")
            print("   Demographics: \(DashboardViewModel.escapedDemographicsJSONString ?? "nil")")
                       print("   Current User: \(payload.currentUserJson)")
        }
        .navigationTitle(pageTitle)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward") // 👈 just the arrow
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
            }
        }
        .tint(.white)
    }
}

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
