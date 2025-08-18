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
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredItems) { item in
                        Button(action: {

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
                prompt: "Search Division"
            )
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
            .onAppear {
                viewModal.fetchDivisions(errorHandler: errorHandler)
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
            divisionId: 1,
            showLogin: 1,
            showBreakminutes: 1,
            name: "John Appleseed",
            master: 1,
            clientContactInfoId: 10
        ),
        DivisionList(
            clientName: "Google LLC",
            clientID: 2,
            contactID: 102,
            divisionName: "Android Division",
            pendingTS: 1,
            divisionId: 2,
            showLogin: 0,
            showBreakminutes: 0,
            name: "Sundar Pichai",
            master: 2,
            clientContactInfoId: 20
        )
    ]
    return vm
}
