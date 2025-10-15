import SwiftUI

struct ProfileActionSheetOnlyView: View {
    @State private var showActionSheet = false
    @State private var showLogoutAlert = false
    @State private var userName: String = "John Doe"
    @State private var divisionName: String = "Sales"
    @Binding var path: [AppRoute] // For navigation

    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                showActionSheet.toggle()
            }) {
                Text("Show Profile Options")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Spacer()
        }
        .confirmationDialog(
            buildDialogTitle(),
            isPresented: $showActionSheet,
            titleVisibility: .visible
        ) {
            Button("Change Password") {
                pushToChangePassword()
            }
            
            Button("Logout", role: .destructive) {
                showLogoutAlert = true
            }
            
            Button("Cancel", role: .cancel) {}
        }
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("OK", role: .destructive) {
                performLogout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }

    // MARK: - Helper Functions
    private func buildDialogTitle() -> String {
        if divisionName.isEmpty {
            return userName
        } else {
            return "\(userName)\n\(divisionName)"
        }
    }

    private func pushToChangePassword() {
        print("Navigate to Change Password screen")
        path.append(.forgotPassword)
    }

    private func performLogout() {
        clearUserDefaults()
        path.append(.login)
    }

    private func clearUserDefaults() {
        let defaults = UserDefaults.standard
        let keysToRemove = [
            "Username", "Password", "refreshToken", "accessToken",
            "expiresIn", "userId", "CandName", "DivisionName"
        ]
        keysToRemove.forEach { defaults.removeObject(forKey: $0) }
        defaults.synchronize()
    }
}

#Preview {
    ProfileActionSheetOnlyView(path: .constant([]))
}
