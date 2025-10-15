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
        .navigationTitle("TemPositions")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showLogoutAlert = true }) {
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
                path: $path, viewModel: dashboardViewModel,
                selectedAssignment: $selectedAssignment,
                showSheet: $showSheet,
                showAlert: $showSheet,
                alertMessage:$alertMessage,
                diviisionImage: "",
                clientName: division.clientName ?? ""
            )
            .tabItem { Image(systemName: "house.fill"); Text("Home") }
            .tag(0)
            
            Top_TabView(division: division)
                .tabItem { Image(systemName: "plus.circle.fill"); Text("Add On") }
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
                if let contactID = division.contactID, let clientId = division.clientID, let divisionId = division.divisionID, let clientName = division.clientName {
                    dashboardViewModel.fetchDashboard(contactID: contactID, clientID: clientId, divisionid: divisionId, clientName: clientName)
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
        path.append(.login)
    }
}

// MARK: - Preview
struct CurveConcavePreviewWrapper: View {
    @State private var path: [AppRoute] = []

    var body: some View {
        let sampleChildren = [
            ChildItem(name: "Algebra", imageName: "notes", apiKey: "link"),
            ChildItem(name: "Geometry", imageName: "notes", apiKey: "link"),
            ChildItem(name: "Trigonometry", imageName: "notes", apiKey: "link")
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
