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
    @State var divisionName: String = ""
    @State var divisionImage: String = ""
    
    var body: some View {
       // Rectangle_Container {
        GeometryReader { geo in
            ZStack {
               
                    VStack(spacing: 6) {
                        Text("\(divisionName)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color.theme.opacity(0.9))
                            .cornerRadius(1)
                    
                        if let url = URL(string: divisionImage), !divisionImage.isEmpty {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView() // show loading spinner
                                        .frame(height: 50)

                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)

                                case .failure:
                                    Image("Splash") // fallback image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                @unknown default:
                                    Image("Splash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                }
                            }
                        } else {
                            // If URL string is empty or invalid
                            Image("Splash")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                        }

//                        Image("Splash")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 50)
                        
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
                            .padding(.top, 12) // 👈 adds spacing at the top of the scroll area
                            .padding(.leading, 0)
                            .padding(.trailing, 0)
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
                path: $path,
                divisionName: "vivek"
            )
        }
    }

    return DashboardScreenPreviewWrapper()
}
