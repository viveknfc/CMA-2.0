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
                CurvedHeader(rectHeight: headerHeight, curveHeight: headerHeight)
                
                // ✅ Centered Header Content
                VStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 10) {
                        // Profile image (with fallback)
                        // Simulated image
                        URLImageView(
                            imageURL: viewModel.divisionImage,
                            contentMode: .fit
                        )
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 2)
                           
                       
                       // Client name that wraps even for long single words
                        Text(insertZeroWidthSpace(in: clientName))
                            .font(.system(size: 12, weight: .bold)) // Set your desired size and weight
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 150) // limit width to allow wrapping
                           
                                   
                        
                      
                    }
                    .padding(.horizontal)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.size.height) { _, newValue in
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        // Add some vertical padding + curve buffer
                                        headerHeight = max(newValue + 90, 100)
                                    }
                                }
                        }
                    )
                    Spacer()
                }
                .frame(height: headerHeight)
                .padding(.top, -10)
                
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
        }
        .background(Color(#colorLiteral(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)))
    }

// Helper: insert zero-width space between letters to allow wrap
    func insertZeroWidthSpace(in text: String) -> String {
        return text.map { String($0) }.joined(separator: "\u{200B}")
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
                clientName: "Test - Office of Asylum Seeker Operations"
            )
        }
    }

    return DashboardScreenPreviewWrapper()
}


// Replace your URLImageView with this improved version:

import SwiftUI

/// Enhanced URL Image View with caching and error handling
struct URLImageView: View {
    let imageURL: String?
    var contentMode: ContentMode = .fit
    var fallbackSystemImage: String = "person.circle.fill"
    
    var body: some View {
        Group {
            if let urlString = imageURL?.trimmingCharacters(in: .whitespaces),
               !urlString.isEmpty,
               let url = URL(string: urlString) {
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        // Loading state
                        ZStack {
                            Color.gray.opacity(0.1)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        }
                        
                    case .success(let image):
                        // Successfully loaded image
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                        
                    case .failure(_):
                        // Failed to load - show fallback
                        fallbackView
                        
                    @unknown default:
                        fallbackView
                    }
                }
            } else {
                // No URL provided - show fallback
                fallbackView
            }
        }
    }
    
    private var fallbackView: some View {
        ZStack {
            Color.gray.opacity(0.1)
            Image(systemName: fallbackSystemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray.opacity(0.6))
                .padding(8)
        }
    }
}

// MARK: - Alternative with Custom Placeholder
struct URLImageViewWithPlaceholder: View {
    let imageURL: String?
    var contentMode: ContentMode = .fit
    var placeholder: AnyView? = nil
    var fallbackSystemImage: String = "person.circle.fill"
    
    var body: some View {
        Group {
            if let urlString = imageURL?.trimmingCharacters(in: .whitespaces),
               !urlString.isEmpty,
               let url = URL(string: urlString) {
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        if let placeholder = placeholder {
                            placeholder
                        } else {
                            defaultLoadingView
                        }
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                        
                    case .failure(_):
                        fallbackView
                        
                    @unknown default:
                        fallbackView
                    }
                }
            } else {
                fallbackView
            }
        }
    }
    
    private var defaultLoadingView: some View {
        ZStack {
            Color.gray.opacity(0.1)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
        }
    }
    
    private var fallbackView: some View {
        ZStack {
            Color.gray.opacity(0.1)
            Image(systemName: fallbackSystemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray.opacity(0.6))
                .padding(8)
        }
    }
}

// MARK: - Usage Examples
struct URLImageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Example 1: Basic usage
            URLImageView(
                imageURL: "https://picsum.photos/200",
                contentMode: .fit
            )
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Example 2: Circle profile image
            URLImageView(
                imageURL: "https://picsum.photos/200",
                contentMode: .fill,
                fallbackSystemImage: "person.circle.fill"
            )
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            // Example 3: With custom placeholder
            URLImageViewWithPlaceholder(
                imageURL: "https://picsum.photos/200",
                contentMode: .fit,
                placeholder: AnyView(
                    Text("Loading...")
                        .foregroundColor(.gray)
                )
            )
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Example 4: Invalid URL (shows fallback)
            URLImageView(
                imageURL: nil,
                contentMode: .fit
            )
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
    }
}
