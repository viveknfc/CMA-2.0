//
//  CurveConcavePreview.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

    struct CurveConcavePreview: View {
        
       @State private var selection: Int = 0
       @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init())
       @State private var radius: CGFloat = 66//96
        @State private var concaveDepth: CGFloat = 0.86//0.96
        @State private var color: Color = .theme//Color(hex: 0x1A4E56)

        @State private var showLogoutAlert = false
        @Environment(\.dismiss) private var dismiss
        @Binding var path: [AppRoute]
        
        @State private var selectedAssignment: Dashboard_Menu_Items? = nil

        @State var dashboardViewModel: DashboardViewModel
        @State private var showSheet = false
        @State private var isDashboardReady = false
       
       var body: some View {
           GeometryReader { proxy in
               ZStack {
                   AxisTabView(selection: $selection, constant: constant) { state in
                       ATCurveStyle(state, color: color, radius: radius, depth: concaveDepth)
                   } content: {
                       
                       ControlView(
                        selection: $selection,
                        constant: $constant,
                        radius: $radius,
                        concaveDepth: $concaveDepth,
                        color: $color,
                        tag: 0,
                        systemName: "house.fill",
                        safeArea: proxy.safeAreaInsets,
                        content: {
                            Dashboard_Screen(viewModel: dashboardViewModel, selectedAssignment: $selectedAssignment, showSheet: $showSheet)
                        }
                       )
                       
                       ControlView(
                        selection: $selection,
                        constant: $constant,
                        radius: $radius,
                        concaveDepth: $concaveDepth,
                        color: $color,
                        tag: 1,
                        systemName: "note.text",
                        safeArea: proxy.safeAreaInsets,
                        content: {
                            Text("Yadhu")
                        }
                       )
                       
                       ControlView(
                        selection: $selection,
                        constant: $constant,
                        radius: $radius,
                        concaveDepth: $concaveDepth,
                        color: $color,
                        tag: 2,
                        systemName: "plus.circle.fill",
                        safeArea: proxy.safeAreaInsets,
                        content: {
                            Text("Papu")
                        }
                       )
                       
                       ControlView(
                        selection: $selection,
                        constant: $constant,
                        radius: $radius,
                        concaveDepth: $concaveDepth,
                        color: $color,
                        tag: 3,
                        systemName: "alarm",
                        safeArea: proxy.safeAreaInsets,
                        content: {
                            Text("Settings")
                        }
                       )
                       
                       ControlView(
                        selection: $selection,
                        constant: $constant,
                        radius: $radius,
                        concaveDepth: $concaveDepth,
                        color: $color,
                        tag: 4,
                        systemName: "person.fill",
                        safeArea: proxy.safeAreaInsets,
                        content: {
                            Text("Other Content")
                        }
                       )
                       
                   } onTapReceive: { selectionTap in
                       
                       if self.selection != selectionTap {
                           DispatchQueue.main.async {
                               let generator = UIImpactFeedbackGenerator(style: .medium)
                               generator.prepare()
                               generator.impactOccurred()
                           }
                       }
                       
                       /// Imperative syntax
                       print("---------------------")
                       print("Selection : ", selectionTap)
                       print("Already selected : ", self.selection == selectionTap)
                   }
                   
                   if selectedAssignment != nil {
                       Color.black.opacity(showSheet ? 0.4 : 0)
                           .ignoresSafeArea()
                           .onTapGesture {
                               withAnimation {
                                   showSheet = false
                               }
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                   selectedAssignment = nil
                               }
                           }

                       VStack {
                           Spacer()
                           ZStack {
                               Color(.systemBackground)

                               if let item = selectedAssignment {
                                   Children_BottomSheet_View(
                                       parentTitle: item.title,
                                       children: item.children ?? [],
                                       onDismiss: {
                                           withAnimation {
                                               showSheet = false
                                           }
                                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                               selectedAssignment = nil
                                           }
                                       }, path: $path
                                   )
                               }
                           }
                           .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                           .frame(maxWidth: .infinity)
                           .frame(height: proxy.size.height * 0.5)
                           .opacity(showSheet ? 1 : 0)
                           .offset(y: showSheet ? 0 : proxy.size.height)
                           .animation(.easeInOut(duration: 0.3), value: showSheet)
                           .zIndex(1)
                       }
                       .ignoresSafeArea()
                   }
                   
                   if !isDashboardReady {
                       Color.black.opacity(0.5)
                           .ignoresSafeArea()
                       TriangleLoader()
                   }

               }
           }
           .onChange(of: dashboardViewModel.isLoading) {
               if !dashboardViewModel.isLoading {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                       isDashboardReady = true
                   }
               }
           }
           .onAppear {
               isDashboardReady = false
               selectedAssignment = nil
               showSheet = false
           }
           .animation(.easeInOut, value: constant)
           .animation(.easeInOut, value: radius)
           .animation(.easeInOut, value: concaveDepth)
           .animation(.easeInOut(duration: 0.3), value: selectedAssignment)

           .navigationTitle("Tempositions")
           .navigationBarTitleDisplayMode(.inline)
           .navigationBarBackButtonHidden(true)
           .toolbar {
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button(action: {
                       print("Global right button tapped")
                       showLogoutAlert = true
                   }) {
                       Image(systemName: "rectangle.portrait.and.arrow.forward")
                           .font(.system(size: 14))
                           .foregroundColor(.white)
                   }
               }
           }
           .overlay(
               Group {
                   if showLogoutAlert {
                       AlertView(
                           image: Image(systemName: "exclamationmark.circle.fill"),
                           title: "Logout",
                           message: "Are you sure you want to logout?",
                           primaryButton: AlertButtonConfig(title: "OK", action: {
                               SessionManager.performLogout(path: &path)
                           }),
                           secondaryButton: AlertButtonConfig(title: "Cancel", action: {}),
                           dismiss: {
                               showLogoutAlert = false
                           }
                       )
                       .transition(.opacity)
                   }
               }
           )
       }
    }


#Preview {
    struct CurveConcavePreviewWrapper: View {
        @State private var path: [AppRoute] = []

        var body: some View {

            let viewModel = DashboardViewModel()

            return CurveConcavePreview(path: $path, dashboardViewModel: viewModel)
        }
    }

    return CurveConcavePreviewWrapper()
}


