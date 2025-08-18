//
//  Dashboard_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 19/07/25.
//

import SwiftUI

struct Dashboard_Screen: View {
    
    @Bindable var viewModel: DashboardViewModel
    @State private var showToast = false
    @State private var toastMessage = ""
    @Binding var selectedAssignment: Dashboard_Menu_Items?
    @Binding var showSheet: Bool
    @Binding var path: [AppRoute]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {

                    VStack(spacing: 16) {
                        
                        Image("Splash")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                        
                        Rectangle_Container {
                            ScrollView {
                                Dashboard_Menu_Collection(
                                    assignments: viewModel.dashboardMenuItems,
                                    showToast: $showToast,
                                    toastMessage: $toastMessage,
                                    selectedAssignment: $selectedAssignment,
                                    showSheet: $showSheet,
                                    path: $path
                                )
                            }
                        }
                    }
                

                if showToast {
                    Toast_View(message: toastMessage)
                        .zIndex(1)
                        .position(x: geo.size.width / 2, y: geo.size.height - 60)
                }

            }
            .animation(.easeInOut, value: selectedAssignment)
        }
    }
}

#Preview {
    struct DashboardScreenPreviewWrapper: View {
        @State private var selectedAssignment: Dashboard_Menu_Items? = nil
        @State private var showSheet: Bool = false
        @State private var path: [AppRoute] = []

        var body: some View {

            let viewModel = DashboardViewModel()

            return Dashboard_Screen(
                viewModel: viewModel,
                selectedAssignment: $selectedAssignment,
                showSheet: $showSheet,
                path: $path
            )
        }
    }

    return DashboardScreenPreviewWrapper()
}
