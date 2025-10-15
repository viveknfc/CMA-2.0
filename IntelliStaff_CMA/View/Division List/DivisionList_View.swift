//
//  DivisionList_View.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 01/08/25.
//

import SwiftUI



struct DivisionList_View: View {
    
    @Binding var path: [AppRoute]
    @State private var searchText = ""
    @Bindable var viewModal: DivisionList_VM
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    @State private var showRetryAlert = false
    
    var filteredItems: [DivisionList] {
        if searchText.isEmpty {
            return viewModal.divisions
        } else {
            return viewModal.divisions.filter {
                ($0.clientName?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.divisionName?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            
            VStack {

                VStack(alignment: .leading, spacing: 5) {
                    Text("Please select appropriate division")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.init(hex: "#212529"))
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.init(hex: "#FFFFFF").opacity(0.2))
                        .cornerRadius(6)

                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.init(hex: "#OB4E5A"))
                        Text("Note: You have rights to multiple divisions.")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.init(hex: "#OB4E5A"))
                            
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.init(hex: "#0dcaf0").opacity(0.2))
                    .cornerRadius(6)

                    Text("Rows highlighted in blue indicate there are pending timeslip(s) for the division")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.init(hex: "#OB4E5A"))
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.init(hex: "#0dcaf0").opacity(0.2))
                        .cornerRadius(6)
                }
                .padding(.horizontal)
                .padding(.top, 4)


                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredItems) { item in
                            Button(action: {
                                let cwaDetails = makeCwaDictDetails(from: item)
                                    
                                    // Save the entire dictionary
                                    UserDefaults.standard.set(cwaDetails, forKey: "cwaDetails")
                                    UserDefaults.standard.synchronize()
                                path.append(.dashboard(division: item))
                            }) {
                                DivisionRow_View(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                }
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "search division"
                )
                .navigationTitle("Divisions")
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
                .onAppear {
                    viewModal.fetchDivisions(errorHandler: errorHandler)
                    
                }
                .onChange(of: viewModal.divisions) { oldValue, newValue in
                    if newValue.isEmpty && !viewModal.isLoading {
                        showRetryAlert = true
                    }
                }
                
            }
            
            if showLogoutAlert {
                Color.black.opacity(0.4) // dim background
                    .ignoresSafeArea()
                    .transition(.opacity)

                AlertView(
                    image: Image(systemName: "exclamationmark.circle.fill"),
                    title: "Logout",
                    message: "Are you sure you want to logout?",
                    primaryButton: AlertButtonConfig(title: "OK", action: {
                        // Clear stored tokens
                        UserDefaults.standard.removeObject(forKey: "Username")
                        UserDefaults.standard.removeObject(forKey: "Password")
                        UserDefaults.standard.removeObject(forKey: "refreshToken")
                        UserDefaults.standard.removeObject(forKey: "accessToken")
                        UserDefaults.standard.removeObject(forKey: "expiresIn")
                        UserDefaults.standard.removeObject(forKey: "userId")
                        
                        path.append(.login)
                    }),
                    secondaryButton: AlertButtonConfig(title: "Cancel", action: {}),
                    dismiss: {
                        showLogoutAlert = false
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ensures full screen
                .transition(.opacity)
            }
            
            if showRetryAlert {
                Color.black.opacity(0.4) // dim background
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                AlertView(
                    image: Image(systemName: "exclamationmark.circle.fill"),
                    message: "No divisions found, please retry",
                    primaryButton: AlertButtonConfig(title: "Retry", action: {
                        viewModal.fetchDivisions(errorHandler: errorHandler)
                    }),
                    dismiss: {
                        showRetryAlert = false
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ensures full screen
                .transition(.opacity)
                
            }
            
            if viewModal.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                TriangleLoader()
            }
            
        }
    }
}

#Preview {
    DivisionList_View(
        path: .constant([]),
        viewModal: mockViewModel
    )
    .environmentObject(GlobalErrorHandler())
}

// MARK: - Preview Mock

@MainActor
private var mockViewModel: DivisionList_VM {
    let vm = DivisionList_VM()
    vm.divisions = [
        DivisionList(
            clientName: "Apple Inc.",
            clientID: 1,
            contactID: 101,
            divisionName: "iOS Division",
            pendingTS: 0,
            divisionID: 1,
            showLogin: 1,
            showBreakminutes: 1,
            name: "John Appleseed",
            master: 1,
            clientContactInfoID: 10
        ),
        DivisionList(
            clientName: "Google LLC",
            clientID: 2,
            contactID: 102,
            divisionName: "Android Division",
            pendingTS: 1,
            divisionID: 2,
            showLogin: 0,
            showBreakminutes: 0,
            name: "Sundar Pichai",
            master: 2,
            clientContactInfoID: 20
        )
    ]
    return vm
}
