////
////  CurveConcavePreview.swift
////  IntelliStaff_EMA
////
////  Created by Vivek Lakshmanan on 18/07/25.
////
//
////import SwiftUI
////
////    struct CurveConcavePreview: View {
////        
////       @State private var selection: Int = 0
////       @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init())
////       @State private var radius: CGFloat = 66//96
////        @State private var concaveDepth: CGFloat = 0.86//0.96
////        @State private var color: Color = .white
////            //.theme//Color(hex: 0x1A4E56)
////
////        @State private var showLogoutAlert = false
////        @Environment(\.dismiss) private var dismiss
////        @Binding var path: [AppRoute]
////        
////        @State private var selectedAssignment: Dashboard_Menu_Items? = nil
////
////        @State var dashboardViewModel: DashboardViewModel
////        let division: DivisionList
////        @State private var showSheet = false
////        @State private var isDashboardReady = false
////        
////        @State private var profileVM = ProfileList_VM()
////       
////       var body: some View {
////           GeometryReader { proxy in
////               ZStack {
////                   AxisTabView(selection: $selection, constant: constant) { state in
////                       ATCurveStyle(state, color: color, radius: radius, depth: concaveDepth)
////                   } content: {
////                       
////                       ControlView(
////                        selection: $selection,
////                        constant: $constant,
////                        radius: $radius,
////                        concaveDepth: $concaveDepth,
////                        color: $color,
////                        tag: 0,
////                        systemName: "house.fill", systemTitile: "",
////                        safeArea: proxy.safeAreaInsets,
////                        content: {
////                            Dashboard_Screen(viewModel: dashboardViewModel, selectedAssignment: $selectedAssignment, showSheet: $showSheet, path: $path, divisionName: division.clientName ?? "")
////                        }
////                       )
////                       
//////                       ControlView(
//////                        selection: $selection,
//////                        constant: $constant,
//////                        radius: $radius,
//////                        concaveDepth: $concaveDepth,
//////                        color: $color,
//////                        tag: 1,
//////                        systemName: "note.text",
//////                        safeArea: proxy.safeAreaInsets,
//////                        content: {
//////                            Text("Second")
//////                        }
//////                       )
////                       
////                       ControlView(
////                        selection: $selection,
////                        constant: $constant,
////                        radius: $radius,
////                        concaveDepth: $concaveDepth,
////                        color: $color,
////                        tag: 2,
////                        systemName: "plus.circle.fill", systemTitile: "",
////                        safeArea: proxy.safeAreaInsets,
////                        content: {
////                            Top_TabView(division: division)
////                        }
////                       )
////                       
//////                       ControlView(
//////                        selection: $selection,
//////                        constant: $constant,
//////                        radius: $radius,
//////                        concaveDepth: $concaveDepth,
//////                        color: $color,
//////                        tag: 3,
//////                        systemName: "alarm",
//////                        safeArea: proxy.safeAreaInsets,
//////                        content: {
//////                            Text("Settings")
//////                        }
//////                       )
////                       
////                       ControlView(
////                        selection: $selection,
////                        constant: $constant,
////                        radius: $radius,
////                        concaveDepth: $concaveDepth,
////                        color: $color,
////                        tag: 4,
////                        systemName: "person.fill", systemTitile: "",
////                        safeArea: proxy.safeAreaInsets,
////                        content: {
////                            Profile_Screen(viewModal: profileVM, clientID: division.clientID ?? 0, contactID: division.contactID ?? 0, showLogoutAlert: $showLogoutAlert, path: $path)
////                        }
////                       )
////                       .ignoresSafeArea()  // ✅ This makes it cover top + sides fully
////                       
////                   } onTapReceive: { selectionTap in
////                       
////                       if self.selection != selectionTap {
////                           DispatchQueue.main.async {
////                               let generator = UIImpactFeedbackGenerator(style: .medium)
////                               generator.prepare()
////                               generator.impactOccurred()
////                           }
////                       }
////                       
////                       /// Imperative syntax
////                       print("---------------------")
////                       print("Selection : ", selectionTap)
////                       print("Already selected : ", self.selection == selectionTap)
////                   }
////                   
////                   if selectedAssignment != nil {
////                       Color.black.opacity(showSheet ? 0.4 : 0)
////                           .ignoresSafeArea()
////                           .onTapGesture {
////                               withAnimation {
////                                   showSheet = false
////                               }
////                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
////                                   selectedAssignment = nil
////                               }
////                           }
////
////                       VStack {
////                           Spacer()
////                           ZStack {
////                               Color(.systemBackground)
////
////                               if let item = selectedAssignment {
////                                   Children_BottomSheet_View(
////                                       parentTitle: item.title,
////                                       children: item.children ?? [],
////                                       division: division,
////                                       onDismiss: {
////                                           withAnimation {
////                                               showSheet = false
////                                           }
////                                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
////                                               selectedAssignment = nil
////                                           }
////                                       }, path: $path
////                                   )
////                               }
////                           }
////                           .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
////                           .frame(maxWidth: .infinity)
////                           .frame(height: proxy.size.height * 0.5)
////                           .opacity(showSheet ? 1 : 0)
////                           .offset(y: showSheet ? 0 : proxy.size.height)
////                           .animation(.easeInOut(duration: 0.3), value: showSheet)
////                           .zIndex(1)
////                       }
////                       .ignoresSafeArea()
////                   }
////                   
////                   if !isDashboardReady {
////                       Color.black.opacity(0.5)
////                           .ignoresSafeArea()
////                       TriangleLoader()
////                   }
////                   
////                   if showLogoutAlert {
////                       Color.black.opacity(0.4)
////                           .ignoresSafeArea()
////                           .transition(.opacity)
////                       
////                       AlertView(
////                           image: Image(systemName: "exclamationmark.circle.fill"),
////                           title: "Logout",
////                           message: "Are you sure you want to logout?",
////                           primaryButton: AlertButtonConfig(title: "OK", action: {
////                               print("logout tapped")
////                               
////                               // Clear stored tokens
////                               UserDefaults.standard.removeObject(forKey: "Username")
////                               UserDefaults.standard.removeObject(forKey: "Password")
////                               UserDefaults.standard.removeObject(forKey: "refreshToken")
////                               UserDefaults.standard.removeObject(forKey: "accessToken")
////                               UserDefaults.standard.removeObject(forKey: "expiresIn")
////                               UserDefaults.standard.removeObject(forKey: "userId")
////                               
////                               path.append(.login)
////                           }),
////                           secondaryButton: AlertButtonConfig(title: "Cancel", action: {}),
////                           dismiss: {
////                               showLogoutAlert = false
////                           }
////                       )
////                       .transition(.opacity)
////                       .zIndex(999) // Ensure it's on top
////                   }
////
////
////               }
////           }
////           
////           .onChange(of: dashboardViewModel.isLoading) {
////               if !dashboardViewModel.isLoading {
////                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
////                       isDashboardReady = true
////                   }
////               }
////           }
////           .onAppear {
////               isDashboardReady = false
////               selectedAssignment = nil
////               showSheet = false
////           }
////           .animation(.easeInOut, value: constant)
////           .animation(.easeInOut, value: radius)
////           .animation(.easeInOut, value: concaveDepth)
////           .animation(.easeInOut(duration: 0.3), value: selectedAssignment)
////
////           .navigationTitle("Tempositions")
////           .navigationBarTitleDisplayMode(.inline)
////           .navigationBarBackButtonHidden(true)
////           .toolbar {
////               ToolbarItem(placement: .navigationBarTrailing) {
////                   Button(action: {
////                       print("Global right button tapped from main tab")
////                       showLogoutAlert = true
////                   }) {
////                       Image(systemName: "rectangle.portrait.and.arrow.forward")
////                           .font(.system(size: 14))
////                           .foregroundColor(.white)
////                   }
////               }
////           }
////       }
////        
////    }
////
////
////#Preview {
////    struct CurveConcavePreviewWrapper: View {
////        @State private var path: [AppRoute] = []
////
////        var body: some View {
////
////            let viewModel = DashboardViewModel()
////
////            return CurveConcavePreview(path: $path, dashboardViewModel: viewModel,             division: DivisionList(
////                clientName: "Acme Corp",
////                clientID: 101,
////                contactID: 202,
////                divisionName: "Sales Division",
////                pendingTS: 3,
////                divisionID: 301,
////                showLogin: 1,
////                showBreakminutes: 0,
////                name: "John Doe",
////                master: 1,
////                clientContactInfoID: 404
////            ))
////        }
////    }
////
////    return CurveConcavePreviewWrapper()
////}
////
////
//import SwiftUI
//
//// MARK: - Main View
//struct CurveConcavePreview: View {
//    
//    // MARK: - State
//    @State private var selection: Int = 0
//    @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init())
//    @State private var radius: CGFloat = 66
//    @State private var concaveDepth: CGFloat = 0.86
//    @State private var color: Color = .theme
//    
//    @State private var showLogoutAlert = false
//    @State private var selectedAssignment: Dashboard_Menu_Items? = nil
//    @State private var showSheet = false
//    @State private var showPrimaryAlert = false
//    @State private var alertMessage = ""
//    @State private var emptyDashboardAlert = false
//    
//    @State var dashboardViewModel: DashboardViewModel
//    @State private var profileVM = ProfileList_VM()
//    
//    @Binding var path: [AppRoute]
//    let division: DivisionList
//    
//    @Environment(\.dismiss) private var dismiss
//    
//    // MARK: - Init
//    init(
//        path: Binding<[AppRoute]>,
//        dashboardViewModel: DashboardViewModel,
//        division: DivisionList
//    ) {
//        self._path = path
//        self._dashboardViewModel = State(initialValue: dashboardViewModel)
//        self.division = division
//        
//        // Customize UITabBar appearance
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.systemGray4.withAlphaComponent(1)
//        appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
//        
//        appearance.stackedLayoutAppearance.selected.iconColor = .theme
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.theme]
//        appearance.stackedLayoutAppearance.normal.iconColor = .gray
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
//        
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
//    
//    // MARK: - Body
//    var body: some View {
//        GeometryReader { proxy in
//            ZStack {
//                tabView
//                
//                bottomSheet(proxy: proxy)
//                
//                alertsOverlay
//            }
//        }
//        .onAppear {
//            selectedAssignment = nil
//            showSheet = false
//        }
//        .animation(.easeInOut, value: constant)
//        .animation(.easeInOut, value: radius)
//        .animation(.easeInOut, value: concaveDepth)
//        .animation(.easeInOut(duration: 0.3), value: selectedAssignment)
//        .navigationTitle("Tempositions")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    showLogoutAlert = true
//                }) {
//                    Image(systemName: "rectangle.portrait.and.arrow.forward")
//                        .font(.system(size: 14))
//                        .foregroundColor(.white)
//                }
//            }
//        }
//    }
//    
//    // MARK: - TabView
//    private var tabView: some View {
//        TabView(selection: $selection) {
//            Dashboard_Screen(
//                viewModel: dashboardViewModel,
//                selectedAssignment: $selectedAssignment,
//                showSheet: $showSheet,
//                path: $path
//            )
//            .tabItem { Image(systemName: "house.fill"); Text("Home") }
//            .tag(0)
//            
//            Top_TabView(
//                division: division
//            )
//            .tabItem { Image(systemName: "plus.circle.fill"); Text("") }
//            .tag(2)
//            
//            Profile_Screen(
//                viewModal: profileVM,
//                clientID: division.clientID ?? 0,
//                contactID: division.contactID ?? 0,
//                showLogoutAlert: $showLogoutAlert,
//                path: $path
//            )
//            .tabItem { Image(systemName: "person.fill"); Text("Profile") }
//            .tag(4)
//        }
//    }
//    
//    // MARK: - Bottom Sheet
//    @ViewBuilder
//    private func bottomSheet(proxy: GeometryProxy) -> some View {
//        if let item = selectedAssignment {
//            Color.black.opacity(showSheet ? 0.4 : 0)
//                .ignoresSafeArea()
//                .onTapGesture {
//                    withAnimation { showSheet = false }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        selectedAssignment = nil
//                    }
//                }
//            
//            VStack {
//                Spacer()
//                ZStack {
//                    Color(.systemBackground)
//                    Children_BottomSheet_View(
//                        parentTitle: item.title,
//                        children: item.children ?? [], division: division,
//                        onDismiss: {
//                            withAnimation { showSheet = false }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                selectedAssignment = nil
//                            }
//                        },
//                        path: $path
//                    )
//                }
//                .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
//                .frame(maxWidth: .infinity)
//                .frame(height: proxy.size.height * 0.5)
//                .opacity(showSheet ? 1 : 0)
//                .offset(y: showSheet ? 0 : proxy.size.height)
//                .animation(.easeInOut(duration: 0.3), value: showSheet)
//            }
//            .ignoresSafeArea()
//        }
//    }
//    
//    // MARK: - Alerts Overlay
//    @ViewBuilder
//    private var alertsOverlay: some View {
//        Group {
//            if showLogoutAlert {
//                AnyView(
//                    AlertView(
//                        image: Image(systemName: "exclamationmark.circle.fill"),
//                        title: "Logout",
//                        message: "Are you sure you want to logout?",
//                        primaryButton: AlertButtonConfig(title: "OK", action: performLogout),
//                        secondaryButton: AlertButtonConfig(title: "Cancel", action: {}),
//                        dismiss: { showLogoutAlert = false }
//                    )
//                    .transition(.opacity)
//                )
//            }
//            
//            if showPrimaryAlert {
//                AnyView(
//                    AlertView(
//                        title: "Primary Device",
//                        message: alertMessage,
//                        primaryButton: AlertButtonConfig(title: "Yes", action: {
//                            showPrimaryAlert = false
//                            path.append(.settings)
//                        }),
//                        secondaryButton: AlertButtonConfig(title: "No", action: { showPrimaryAlert = false }),
//                        dismiss: { showPrimaryAlert = false }
//                    )
//                    .transition(.opacity)
//                )
//            }
//            
//            if emptyDashboardAlert {
//                AnyView(
//                    AlertView(
//                        title: "Alert",
//                        message: "No data available. please retry?",
//                        primaryButton: AlertButtonConfig(title: "Retry", action: {
//                            emptyDashboardAlert = false
//                            dashboardViewModel.fetchDashboard()
//                        }),
//                        dismiss: { emptyDashboardAlert = false }
//                    )
//                    .transition(.opacity)
//                )
//            }
//        }
//    }
//
//    
//    // MARK: - Logout
//    private func performLogout() {
//        UserDefaults.standard.removeObject(forKey: "isRemembered")
//        UserDefaults.standard.removeObject(forKey: "savedUsername")
//        UserDefaults.standard.removeObject(forKey: "savedPassword")
//        path = [.login]
//    }
//}
//
//// MARK: - Preview
//struct CurveConcavePreviewWrapper: View {
//    @State private var path: [AppRoute] = []
//
//    var body: some View {
//        let sampleChildren = [
//            ChildItem(name: "Algebra", imageName: "notes", apiKey: "link"),
//            ChildItem(name: "Geometry", imageName: "notes", apiKey: "link"),
//            ChildItem(name: "Trigonometry", imageName: "notes", apiKey: "link")
//        ]
//
//        let sampleAssignments: [Dashboard_Menu_Items] = [
//            Dashboard_Menu_Items(title: "Math", imageName: "book.closed", itemCount: 4, children: sampleChildren),
//            Dashboard_Menu_Items(title: "Science", imageName: "flask.fill", itemCount: 2, children: sampleChildren)
//        ]
//
//        let viewModel = DashboardViewModel()
//        viewModel.dashboardMenuItems = sampleAssignments
//
//        let sampleDivision = DivisionList(clientName: "", clientID: 0, contactID: 0, divisionName: "", pendingTS: 0, divisionID: 0, showLogin: 0, showBreakminutes: 0, name: "", master: 0, clientContactInfoID: 0)
//
//        return CurveConcavePreview(
//            path: $path,
//            dashboardViewModel: viewModel,
//            division: sampleDivision
//        )
//    }
//}
//
//  CurveConcavePreview.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

// MARK: - Main View
struct CurveConcavePreview: View {
    
    // MARK: - State
    @State private var selection: Int = 0
    @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init())
    @State private var radius: CGFloat = 66
    @State private var concaveDepth: CGFloat = 0.86
    @State private var color: Color = .theme
    
    @State private var showLogoutAlert = false
    @State private var selectedAssignment: Dashboard_Menu_Items? = nil
    @State private var showSheet = false
    @State private var showPrimaryAlert = false
    @State private var alertMessage = ""
    @State private var emptyDashboardAlert = false
    
    @State var dashboardViewModel: DashboardViewModel
    @State private var profileVM = ProfileList_VM()
    
    @Binding var path: [AppRoute]
    let division: DivisionList
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Init
    init(
        path: Binding<[AppRoute]>,
        dashboardViewModel: DashboardViewModel,
        division: DivisionList
    ) {
        self._path = path
        self._dashboardViewModel = State(initialValue: dashboardViewModel)
        self.division = division
        
        // Customize UITabBar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray4.withAlphaComponent(1)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
        
        appearance.stackedLayoutAppearance.selected.iconColor = .theme
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.theme]
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                tabView
                bottomSheet(proxy: proxy)
                alertLayers // ✅ simplified alert handling
            }
        }
        .onAppear {
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
                    showLogoutAlert = true
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - TabView
    private var tabView: some View {
        TabView(selection: $selection) {
            Dashboard_Screen(
                viewModel: dashboardViewModel,
                selectedAssignment: $selectedAssignment,
                showSheet: $showSheet,
                path: $path
            )
            .tabItem { Image(systemName: "house.fill"); Text("Home") }
            .tag(0)
            
            Top_TabView(division: division)
                .tabItem { Image(systemName: "plus.circle.fill"); Text("") }
                .tag(2)
            
            Profile_Screen(
                viewModal: profileVM,
                clientID: division.clientID ?? 0,
                contactID: division.contactID ?? 0,
                showLogoutAlert: $showLogoutAlert,
                path: $path
            )
            .tabItem { Image(systemName: "person.fill"); Text("Profile") }
            .tag(4)
        }
    }
    
    // MARK: - Bottom Sheet
    @ViewBuilder
    private func bottomSheet(proxy: GeometryProxy) -> some View {
        if let item = selectedAssignment {
            Color.black.opacity(showSheet ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { showSheet = false }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedAssignment = nil
                    }
                }
            
            VStack {
                Spacer()
                ZStack {
                    Color(.systemBackground)
                    Children_BottomSheet_View(
                        parentTitle: item.title,
                        children: item.children ?? [],
                        division: division,
                        onDismiss: {
                            withAnimation { showSheet = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                selectedAssignment = nil
                            }
                        },
                        path: $path
                    )
                }
                .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                .frame(maxWidth: .infinity)
                .frame(height: proxy.size.height * 0.5)
                .opacity(showSheet ? 1 : 0)
                .offset(y: showSheet ? 0 : proxy.size.height)
                .animation(.easeInOut(duration: 0.3), value: showSheet)
            }
            .ignoresSafeArea()
        }
    }
    
    // MARK: - Alerts Layer
    @ViewBuilder
    private var alertLayers: some View {
        ZStack {
            if showLogoutAlert { logoutAlertView }
            if emptyDashboardAlert { emptyDashboardAlertView }
        }
    }
    
    // MARK: - Individual Alerts
    
    private var logoutAlertView: some View {
        AlertView(
            image: Image(systemName: "exclamationmark.circle.fill"),
            title: "Logout",
            message: "Are you sure you want to logout?",
            primaryButton: AlertButtonConfig(title: "OK", action: performLogout),
            secondaryButton: AlertButtonConfig(title: "Cancel", action: {}),
            dismiss: { showLogoutAlert = false }
        )
        .transition(.opacity)
        .zIndex(999)
    }
    
   
    
    private var emptyDashboardAlertView: some View {
        AlertView(
            title: "Alert",
            message: "No data available. Please retry?",
            primaryButton: AlertButtonConfig(title: "Retry", action: {
                emptyDashboardAlert = false
                if let contactID = division.contactID, let clientId = division.clientID, let divisionId = division.divisionID {
                    dashboardViewModel.fetchDashboard(contactID: contactID, clientID: clientId, divisionid: divisionId)
                }
            }),
            dismiss: { emptyDashboardAlert = false }
        )
        .transition(.opacity)
        .zIndex(997)
    }
    
    // MARK: - Logout Action
    private func performLogout() {
        UserDefaults.standard.removeObject(forKey: "isRemembered")
        UserDefaults.standard.removeObject(forKey: "savedUsername")
        UserDefaults.standard.removeObject(forKey: "savedPassword")
        path = [.login]
    }
}

// MARK: - Preview
struct CurveConcavePreviewWrapper: View {
    @State private var path: [AppRoute] = []

    var body: some View {
        let sampleChildren = [
            ChildItem(name: "Algebra",  apiKey: "link"),
            ChildItem(name: "Geometry",  apiKey: "link"),
            ChildItem(name: "Trigonometry",  apiKey: "link")
        ]

        let sampleAssignments: [Dashboard_Menu_Items] = [
            Dashboard_Menu_Items(title: "Math", imageName: "book.closed", itemCount: 4, children: sampleChildren),
            Dashboard_Menu_Items(title: "Science", imageName: "flask.fill", itemCount: 2, children: sampleChildren)
        ]

        //let viewModel = DashboardViewModel()
        //viewModel.dashboardMenuItems = sampleAssignments
        let viewModel = DashboardViewModel.mock(with: sampleAssignments)

        let sampleDivision = DivisionList(
            clientName: "Acme Corp",
            clientID: 1,
            contactID: 1,
            divisionName: "Division A",
            pendingTS: 0,
            divisionID: 1,
            showLogin: 0,
            showBreakminutes: 0,
            name: "",
            master: 0,
            clientContactInfoID: 0
        )

        return CurveConcavePreview(
            path: $path,
            dashboardViewModel: viewModel,
            division: sampleDivision
        )
    }
}
