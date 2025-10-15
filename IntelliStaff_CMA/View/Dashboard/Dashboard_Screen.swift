//
//  Dashboard_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 19/07/25.
//

import SwiftUI

struct Dashboard_Screen: View {
    @Binding var path: [AppRoute]
    @Bindable var viewModel: DashboardViewModel
    @State private var showToast = false
    @State private var toastMessage = ""
    @Binding var selectedAssignment: Dashboard_Menu_Items?
    @Binding var showSheet: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    var diviisionImage: String
    var clientName: String

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                
                CurvedHeader(rectHeight: 125, curveHeight: 110)
                
                VStack(spacing: 5) {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        // ✅ Change VStack to HStack for side-by-side alignment
                        HStack(spacing: 8) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            
                            Text("\(clientName)")
                                .font(.bodyFont)
                                .foregroundColor(.white)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, 13)
                    }
                    
                    Spacer().frame(height: 80)
                    
                    ScrollView {
                        Dashboard_Menu_Collection(
                            assignments: viewModel.dashboardMenuItems,
                            showToast: $showToast,
                            toastMessage: $toastMessage,
                            selectedAssignment: $selectedAssignment,
                            showSheet: $showSheet,
                            path: $path // ✅ FIXED: pass actual path binding
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 88)
                    }
                }
                
                if showToast {
                    Toast_View(message: toastMessage)
                        .zIndex(1)
                        .position(x: geo.size.width / 2, y: geo.size.height - 60)
                }
            }
            .animation(.easeInOut, value: selectedAssignment)
            .onChange(of: viewModel.showAlert) { _, newValue in
                if newValue {
                    showAlert = true
                    alertMessage = viewModel.alertMessage
                    viewModel.showAlert = false
                }
            }
            .background(Color(#colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)))
        }
        .animation(.easeInOut, value: selectedAssignment)
    }
}

#Preview {
    struct DashboardScreenPreviewWrapper: View {
        @State private var selectedAssignment: Dashboard_Menu_Items? = nil
        @State private var showSheet: Bool = false
        @State private var showAlert: Bool = false
        @State private var alertMessage = ""
        @State private var path: [AppRoute] = []
        
        var body: some View {
            let sampleChildren = [
                ChildItem(name: "Algebra", imageName: "banknote", apiKey: "link"),
                ChildItem(name: "Geometry", imageName: "banknote", apiKey: "link"),
                ChildItem(name: "Trigonometry", imageName: "banknote", apiKey: "link")
            ]

            let sampleAssignments: [Dashboard_Menu_Items] = [
                Dashboard_Menu_Items(title: "Math", imageName: "book.closed", itemCount: 4, children: sampleChildren),
                Dashboard_Menu_Items(title: "Science", imageName: "flask.fill", itemCount: 2, children: sampleChildren),
                Dashboard_Menu_Items(title: "History", imageName: "clock", itemCount: 0, children: nil),
                Dashboard_Menu_Items(title: "Art", imageName: "paintbrush", itemCount: 5, children: sampleChildren),
                Dashboard_Menu_Items(title: "PE", imageName: "figure.walk", itemCount: 3, children: sampleChildren),
                Dashboard_Menu_Items(title: "Music", imageName: "music.note", itemCount: 1, children: sampleChildren),
                Dashboard_Menu_Items(title: "Site", imageName: "house", itemCount: 0, children: nil) // ✅ Added Site button for testing
            ]

            let viewModel = DashboardViewModel()
            viewModel.dashboardMenuItems = sampleAssignments

            return Dashboard_Screen(
                path: $path,
                viewModel: viewModel,
                selectedAssignment: $selectedAssignment,
                showSheet: $showSheet,
                showAlert: $showAlert,
                alertMessage: $alertMessage,
                diviisionImage: "",
                clientName: "Sample Client"
            )
        }
    }

    return DashboardScreenPreviewWrapper()
}
