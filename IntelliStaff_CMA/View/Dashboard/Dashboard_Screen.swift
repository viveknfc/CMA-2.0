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
   
    
    var body: some View {
       // Rectangle_Container {
//        GeometryReader { geo in
//            ZStack {
        
        GeometryReader { geo in
            ZStack(alignment: .top) {
                
                CurvedHeader(rectHeight: 100, curveHeight: 100, imageURL: "Splash", clientName: divisionName)
                
                
                VStack(spacing: 0) {
                    
//                    Rectangle_Container(alignment: .topLeading) {
//                        AssignmentList_View(assignmentData: viewModel.assignmentItems)
//                    }
//                    .frame(height: 200)
//                    .padding(.horizontal, 16)
//                    .padding(.top, 10)
                    
                    Spacer().frame(height: 120)
                    
                    
                    
//                    VStack(spacing: 6) {
//                        Text("\(divisionName)")
//                            .font(.system(size: 12, weight: .bold))
//                            .foregroundColor(Color.init(hex: "#272d6b"))
//                            .padding(2)
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .background(.clear)
//                            .cornerRadius(1)
                        
//                        if let url = URL(string: viewModel.divisionImage ?? ""), !viewModel.divisionImage.isEmpty {
//                            AsyncImage(url: url) { phase in
//                                switch phase {
//                                case .empty:
//                                    ProgressView() // show loading spinner
//                                        .frame(height: 50)
//                                    
//                                case .success(let image):
//                                    image
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 50)
//                                    
//                                case .failure:
//                                    Image("Splash") // fallback image
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 50)
//                                @unknown default:
//                                    Image("Splash")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 50)
//                                }
//                            }
//                        } else {
                            // If URL string is empty or invalid
//                            Image("Splash")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(height: 50)
//                        }
                        
                        //                        Image("Splash")
                        //                            .resizable()
                        //                            .scaledToFit()
                        //                            .frame(height: 50)
                        
                        ScrollView {
                            Dashboard_Menu_Collection(
                                assignments: viewModel.dashboardMenuItems, showToast: $showToast,
                                toastMessage: $toastMessage,
                                selectedAssignment: $selectedAssignment,
                                showSheet: $showSheet
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

//import SwiftUI
//
//struct Dashboard_Screen: View {
//    
//    @Bindable var viewModel: DashboardViewModel // ✅ USE THIS
//    @State private var showToast = false
//    @State private var toastMessage = ""
//    @Binding var selectedAssignment: Dashboard_Menu_Items?
//    @Binding var showSheet: Bool
//    
//    @Binding var showAlert: Bool
//    @Binding var alertMessage: String
//    
//    var body: some View {
//        GeometryReader { geo in
//            ZStack(alignment: .top) {
//                
//                CurvedHeader(rectHeight: 200, curveHeight: 100)
//
//                
//                VStack(spacing: 0) {
//                    
//                    Rectangle_Container(alignment: .topLeading) {
//                        AssignmentList_View(assignmentData: viewModel.assignmentItems)
//                    }
//                    .frame(height: 200)
//                    .padding(.horizontal, 16)
//                    .padding(.top, 10)
//                    
//                    Spacer().frame(height: 20)
//                        
//                    ScrollView {
//                        Dashboard_Menu_Collection(
//                            assignments: viewModel.dashboardMenuItems,
//                            showToast: $showToast,
//                            toastMessage: $toastMessage,
//                            selectedAssignment: $selectedAssignment, showSheet: $showSheet
//                        )
//                        .padding(.top, 20)
//                        .padding(.bottom, 88)
//                    }
//                }
//
//                if showToast {
//                    Toast_View(message: toastMessage)
//                        .zIndex(1)
//                        .position(x: geo.size.width / 2, y: geo.size.height - 60)
//                }
//            }
//            .animation(.easeInOut, value: selectedAssignment)
//        }
//    }
//        
//}
//
//#Preview {
//    struct DashboardScreenPreviewWrapper: View {
//        @State private var selectedAssignment: Dashboard_Menu_Items? = nil
//        @State private var showSheet: Bool = false
//        @State private var path: [AppRoute] = []
//
//        var body: some View {
//
//            let viewModel = DashboardViewModel()
//
//            return Dashboard_Screen(
//                viewModel: viewModel,
//                selectedAssignment: $selectedAssignment,
//                showSheet: $showSheet,
//                path: $path,
//                divisionName: "vivek"
//            )
//        }
//    }
//
//    return DashboardScreenPreviewWrapper()
//}
//
//
#Preview {
    struct DashboardScreenPreviewWrapper: View {
        @State private var selectedAssignment: Dashboard_Menu_Items? = nil
        @State private var showSheet: Bool = false // ✅ Added
        @State private var showAlert: Bool = false
        @State private var alertMessage = ""
        @State private var dummyPath: [AppRoute] = []
        var body: some View {
            let sampleChildren = [
                ChildItem(name: "Algebra",  apiKey: "link"),
                ChildItem(name: "Geometry",  apiKey: "link"),
                ChildItem(name: "Trigonometry",  apiKey: "link")
            ]

            let sampleAssignments: [Dashboard_Menu_Items] = [
                Dashboard_Menu_Items(title: "Math", imageName: "book.closed", itemCount: 4, children: sampleChildren),
                Dashboard_Menu_Items(title: "Science", imageName: "flask.fill", itemCount: 2, children: sampleChildren),
                Dashboard_Menu_Items(title: "History", imageName: "clock", itemCount: 0, children: nil),
                Dashboard_Menu_Items(title: "Art", imageName: "paintbrush", itemCount: 5, children: sampleChildren),
                Dashboard_Menu_Items(title: "PE", imageName: "figure.walk", itemCount: 3, children: sampleChildren),
                Dashboard_Menu_Items(title: "Music", imageName: "music.note", itemCount: 1, children: sampleChildren)
            ]

          //  let viewModel = DashboardViewModel()
           // viewModel.dashboardMenuItems = sampleAssignments
            let viewModel = DashboardViewModel.mock(with: sampleAssignments)
            return Dashboard_Screen(
                viewModel: viewModel,
                selectedAssignment: $selectedAssignment,
                showSheet: $showSheet, path: $dummyPath // ✅ Passed binding
//                showAlert: $showAlert,
//                alertMessage: $alertMessage
            )
        }
    }

    return DashboardScreenPreviewWrapper()
}


