//
//  ProfileActionSheet.swift
//  IntelliStaff_CMA
//
//  Created by ios on 12/09/25.
//

import SwiftUI

struct ProfileActionSheetView: View {
    @State private var showActionSheet = false
    @State private var userName: String = ""
    @State private var divisionName: String = ""
    @Binding var path: [AppRoute]
     private var showLogoutAlert = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Main Content Here")
                    .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showActionSheet.toggle()
                    }) {
                        Image("user_profile") // same image as in UIKit
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                }
            }
            .onAppear {
                // Load values from UserDefaults
                let defaults = UserDefaults.standard
                userName = defaults.string(forKey: "CandName") ?? "Unknown User"
                divisionName = defaults.string(forKey: "DivisionName") ?? ""
            }
            .confirmationDialog(
                "\(userName)\(divisionName.isEmpty ? "" : "\n\(divisionName)")",
                isPresented: $showActionSheet,
                titleVisibility: .visible
            ) {
                Button("Change Password") {
                    pushToChangePassword()
                }
                Button("Logout", role: .destructive) {
                    resetDefaults()
                    // Navigation handling here
                    print("Pop to root in SwiftUI")
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    // MARK: - Functions
    
    private func pushToChangePassword() {
        // Navigation action to ChangePassword screen
        print("Navigate to Change Password screen")
        path.append(.forgotPassword)
    }
    
    private  func resetDefaults() {
        // Clear UserDefaults
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        UserDefaults.standard.synchronize()
        
       // if showLogoutAlert {
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
                   // showLogoutAlert = false
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity) // ensures full screen
            .transition(.opacity)
        //}
    }
}
