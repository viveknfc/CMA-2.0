//
//  WebView_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 24/07/25.
//

import SwiftUI

struct WebView_Screen: View {
    
    let urlKey: String
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let fullURL = URL(string: "https://www.google.com/")!

        ZStack {
            WebView(url: fullURL, isLoading: $isLoading)
            
            if isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                TriangleLoader()
            }
        }
        .navigationTitle("Tempositions")
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

#Preview {

    WebView_Screen(urlKey: "https://www.google.com/")
    
}
