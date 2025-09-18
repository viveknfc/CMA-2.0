//
//  ContentView.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path: [AppRoute] = []
    @State private var dashboardViewModel = DashboardViewModel()
    init() {
        AppAppearance.setupNavigationBar()
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            Login_Screen(path: $path) // Initial screen
                .navigationDestination(for: AppRoute.self) { route in
                    route.destinationView(path: $path, dashboardViewModel: dashboardViewModel)
                }
        }
        .withGlobalOverlay()
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalErrorHandler())
}
