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
    
    // Dynamic header height
    @State private var headerHeight: CGFloat = 140
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                
                // ✅ Dynamic Curved Header
                CurvedHeader(rectHeight: headerHeight, curveHeight: headerHeight - 25)
                    .animation(.easeInOut(duration: 0.3), value: headerHeight)
                
                // ✅ Centered Header Content
                VStack {
                    Spacer()
                    HStack(alignment: .center, spacing: 10) {
                        // Profile image (with fallback)
                        if let urlString = viewModel.divisionImage,
                           let url = URL(string: urlString),
                           !urlString.isEmpty {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 45, height: 45)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 1))
                                        .shadow(radius: 3)
                                default:
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        // Client name text
                        Text(clientName)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.size.height) { _, newValue in
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        // Add some vertical padding + curve buffer
                                        headerHeight = max(newValue + 100, 125)
                                    }
                                }
                        }
                    )
                    Spacer()
                }
                .frame(height: headerHeight)
                .padding(.top, -45)
                
                // ✅ Main Scroll Content
                VStack {
                    Spacer().frame(height: headerHeight + 35)
                    
                    ScrollView {
                        Dashboard_Menu_Collection(
                            assignments: viewModel.dashboardMenuItems,
                            showToast: $showToast,
                            toastMessage: $toastMessage,
                            selectedAssignment: $selectedAssignment,
                            showSheet: $showSheet,
                            path: $path
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 88)
                    }
                }
                
                // ✅ Toast Overlay
                if showToast {
                    Toast_View(message: toastMessage)
                        .zIndex(1)
                        .position(x: geo.size.width / 2, y: geo.size.height - 60)
                }
            }
            .onChange(of: viewModel.showAlert) { _, newValue in
                if newValue {
                    showAlert = true
                    alertMessage = viewModel.alertMessage
                    viewModel.showAlert = false
                }
            }
            .background(Color(#colorLiteral(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)))
        }
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
