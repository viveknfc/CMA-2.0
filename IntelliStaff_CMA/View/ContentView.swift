//
//  ContentView.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path: [AppRoute] = []
    
    init() {
        AppAppearance.setupNavigationBar()
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            Login_Screen(path: $path) // Initial screen
                .navigationDestination(for: AppRoute.self) { route in
                    route.destinationView(path: $path)
                }
        }
        .withGlobalOverlay()
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalErrorHandler())
}
