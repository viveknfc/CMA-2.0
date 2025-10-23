//
//  NewPassword_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

//struct NewPassword_Screen: View {
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
//    @State var isLoginActive = false
//    @State private var showAlert = false
//    @State private var successAlert = false
//    @State private var alertMessage = ""
//    @Environment(\.dismiss) var dismiss
//    @Binding var path: [AppRoute]
//    var email: String
//    @State private var viewModel = UpdatePasswordViewModel()
//    @EnvironmentObject var errorHandler: GlobalErrorHandler
//   
//
//    // ✅ Password validation helper
//    private func isValidPassword(_ password: String) -> Bool {
//        // At least 1 letter, 1 digit, 1 special character, total length 8–20
//        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,20}$"
//        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//    }
//
//
//    var body: some View {
//        ZStack {
//            Color.white
//                .ignoresSafeArea()
//                .onTapGesture { UIApplication.shared.endEditing() }
//            
//            Color.clear
//                .contentShape(Rectangle())
//                .ignoresSafeArea()
//                .onTapGesture {}
//            
//            VStack(spacing: 0) {
//                Image("CMA icon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 300, height: 150)
//                    .padding(.top, 0)
//
//                VStack(alignment: .leading, spacing: 12) {
//                    HStack(spacing: 0) {
//                        Image(systemName: "info.circle")
//                            .padding(.trailing, 8) // 👈 creates space only after the icon
//                        Text("Password must contain at least one number, one letter, and be a minimum length of 8 characters with a maximum length of 20 characters.")
//                            .font(.system(size: 10, weight: .bold))
//                            .foregroundColor(.black)
//                    }
//                    .padding(8)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background(Color.init(hex: "#d4f0f5"))
//                    .cornerRadius(6)
//                    
//                    Text("Set a new password")
//                        .font(.titleFont)
//
//                    Text("Create a new password. Ensure it differs from previous ones for security reasons.")
//                        .font(.bodyFont)
//                        .padding(.bottom, 8)
//                    
//                    VStack(alignment: .leading, spacing: 4) {
//                        if !password.isEmpty && !isValidPassword(password) {
//                            Text("Password must contain at least 1 letter, 1 number, and be 8–20 characters.")
//                                .font(.caption)
//                                .foregroundColor(.red)
//                        }
//
//                        if !confirmPassword.isEmpty && confirmPassword != password {
//                            Text("Passwords do not match.")
//                                .font(.caption)
//                                .foregroundColor(.red)
//                        }
//                    }
//
//
//                    VStack(spacing: 20) {
//                        UnderlinedTF(
//                            title: "Password",
//                            text: $password,
//                            isSecure: true,
//                            borderColor: password.isEmpty ? .black : (isValidPassword(password) ? .black : .red)
//                        )
//                        
//                        UnderlinedTF(
//                            title: "Confirm Password",
//                            text: $confirmPassword,
//                            isSecure: true,
//                            borderColor: confirmPassword.isEmpty ? .black : (confirmPassword == password ? .black : .red)
//                        )
//                    }
//                    .padding(.top, 10)
//
//                    // Validation messages stacked
//                   
//
//
//                    Capsule_Button(title: "Update password") {
//                        if password.isEmpty || confirmPassword.isEmpty {
//                            alertMessage = "Password / Confirm Password cannot be empty!"
//                            showAlert = true
//                        } else if password != confirmPassword {
//                            alertMessage = "Password / Confirm Password should be the same."
//                            showAlert = true
//                        } else if !isValidPassword(password) {
//                            alertMessage = "Password must be 8–20 characters, contain at least one letter and one number."
//                            showAlert = true
//                        } else {
//                            Task {
//                                let response = await viewModel.updatePassword(
//                                    email: email,
//                                    password: password,
//                                    errorHandler: errorHandler
//                                )
//                                alertMessage = response?.message ?? ""
//                                successAlert = true
//                            }
//                        }
//
//                        print("Update Password tapped")
//                    }
//                    .padding(.top, 30)
//                    .padding([.leading, .trailing], 0)
//                }
//                .padding(.horizontal, 24)
//                .padding(.top, 20)
//
//                Spacer()
//            }
//            .frame(maxHeight: .infinity, alignment: .top)
//            .navigationTitle("Update Password")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden(true)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                    }
//                }
//            }
//
//            // Alerts
//            if showAlert {
//                AlertView(
//                    image: Image(systemName: "xmark.octagon.fill"),
//                    title: "Alert",
//                    message: alertMessage,
//                    primaryButton: AlertButtonConfig(title: "OK", action: {}),
//                    dismiss: { showAlert = false },
//                    alertType: .error
//                )
//                .transition(.opacity)
//                .animation(.easeInOut, value: showAlert)
//                
//            }
//
//            if successAlert {
//                AlertView(
//                    title: "Alert",
//                    message: alertMessage,
//                    primaryButton: AlertButtonConfig(title: "Ok", action: {
//                        showAlert = false
//                        path.append(.login)
//                    }),
//                    dismiss: { showAlert = false },
//                    alertType: .success
//                )
//                .transition(.opacity)
//            }
//
//            if viewModel.isLoading {
//                Color.black.opacity(0.5).ignoresSafeArea()
//                TriangleLoader()
//            }
//        }
//        
//    }
//}



//#Preview {
//    struct NewPasswordScreenPreviewWrapper: View {
//        @State private var path: [AppRoute] = []
//
//        var body: some View {
//            NavigationStack(path: $path) {
//                NewPassword_Screen(path: $path, email: "")
//            }
//        }
//    }
//
//    return NewPasswordScreenPreviewWrapper()
//}
//
//  NewPassword_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

struct NewPassword_Screen: View {
    @State private var currentPassword: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State var isLoginActive = false
    @State private var showAlert = false
    @State private var successAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) var dismiss
    @Binding var path: [AppRoute]
    var email: String
    @State private var viewModel = UpdatePasswordViewModel()
    @EnvironmentObject var errorHandler: GlobalErrorHandler
   

    // ✅ Password validation helper
    private func isValidPassword(_ password: String) -> Bool {
        // At least 1 letter, 1 digit, 1 special character, total length 8–20
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // ✅ Validate current password against UserDefaults
    private func isCurrentPasswordValid() -> Bool {
        guard let storedPassword = UserDefaults.standard.string(forKey: "savedPassword") else {
            return false
        }
        return currentPassword == storedPassword
    }


    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .onTapGesture { UIApplication.shared.endEditing() }
            
            Color.clear
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .onTapGesture {}
            
            VStack(spacing: 0) {
                Image("CMA icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 150)
                    .padding(.top, 0)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 0) {
                        Image(systemName: "info.circle")
                            .padding(.trailing, 8)
                        Text("Password must contain at least one number, one letter, and be a minimum length of 8 characters with a maximum length of 20 characters.")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color.init(hex: "#0B4E5A"))
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.init(hex: "#d4f0f5"))
                    .cornerRadius(6)
                    
//                    Text("Set a new password")
//                        .font(.titleFont)
//
//                    Text("Create a new password. Ensure it differs from previous ones for security reasons.")
//                        .font(.bodyFont)
//                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        if !currentPassword.isEmpty && !isCurrentPasswordValid() {
                            Text("Current password is incorrect.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        if !password.isEmpty && !isValidPassword(password) {
                            Text("Password must contain at least 1 letter, 1 number, and be 8–20 characters.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }

                        if !confirmPassword.isEmpty && confirmPassword != password {
                            Text("Passwords do not match.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }


                    VStack(spacing: 20) {
                        UnderlinedTF(
                            title: "Current Password",
                            text: $currentPassword,
                            isSecure: true,
                            borderColor: currentPassword.isEmpty ? .black : (isCurrentPasswordValid() ? .black : .red)
                        )
                        
                        UnderlinedTF(
                            title: "New Password",
                            text: $password,
                            isSecure: true,
                            borderColor: password.isEmpty ? .black : (isValidPassword(password) ? .black : .red)
                        )
                        
                        UnderlinedTF(
                            title: "Confirm Password",
                            text: $confirmPassword,
                            isSecure: true,
                            borderColor: confirmPassword.isEmpty ? .black : (confirmPassword == password ? .black : .red)
                        )
                    }
                    .padding(.top, 10)

                    Capsule_Button(title: "Change password") {
                        if currentPassword.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                            alertMessage = "All password fields are required!"
                            showAlert = true
                        } else if !isCurrentPasswordValid() {
                            alertMessage = "Current password is incorrect."
                            showAlert = true
                        } else if password != confirmPassword {
                            alertMessage = "Password / Confirm Password should be the same."
                            showAlert = true
                        } else if !isValidPassword(password) {
                            alertMessage = "Password must be 8–20 characters, contain at least one letter and one number."
                            showAlert = true
                        } else if currentPassword == password {
                            alertMessage = "New password must be different from current password."
                            showAlert = true
                        } else {
                            Task {
                                let response = await viewModel.updatePassword(
                                    email: email,
                                    password: password,
                                    errorHandler: errorHandler
                                )
                                alertMessage = response?.message ?? ""
                                successAlert = true
                            }
                        }

                        print("Update Password tapped")
                    }
                    .padding(.top, 30)
                    .padding([.leading, .trailing], 0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Update Password")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }

            // Alerts
            if showAlert {
                AlertView(
                    image: Image(systemName: "xmark.octagon.fill"),
                    title: "Alert",
                    message: alertMessage,
                    primaryButton: AlertButtonConfig(title: "OK", action: {}),
                    dismiss: { showAlert = false },
                    alertType: .error
                )
                .transition(.opacity)
                .animation(.easeInOut, value: showAlert)
                
            }

            if successAlert {
                AlertView(
                    title: "Alert",
                    message: alertMessage,
                    primaryButton: AlertButtonConfig(title: "Ok", action: {
                        showAlert = false
                        path.append(.login)
                    }),
                    dismiss: { showAlert = false },
                    alertType: .success
                )
                .transition(.opacity)
            }

            if viewModel.isLoading {
                Color.black.opacity(0.5).ignoresSafeArea()
                TriangleLoader()
            }
        }
        
    }
}



#Preview {
    struct NewPasswordScreenPreviewWrapper: View {
        @State private var path: [AppRoute] = []

        var body: some View {
            NavigationStack(path: $path) {
                NewPassword_Screen(path: $path, email: "")
            }
        }
    }

    return NewPasswordScreenPreviewWrapper()
}
