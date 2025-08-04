//
//  NewPassword_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

struct NewPassword_Screen: View {
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State var isLoginActive = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) var dismiss
    @Binding var path: [AppRoute]

    var body: some View {

            ZStack {
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                // Prevent interactions behind the alert
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {} // absorbs tap to block nav buttons

                VStack(spacing: 0) {
                    Image("Splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .padding(.top, 40)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Set a new password")
                            .font(.titleFont)

                        Text("Create a new password. Ensure it differs from previous ones for security reasons.")
                            .font(.bodyFont)
                            .padding(.bottom, 8)

                        VStack(spacing: 20) {
                            UnderlinedTF(title: "Password", text: $password, isSecure: true)
                            UnderlinedTF(title: "Confirm Password", text: $confirmPassword, isSecure: true)
                        }
                        .padding(.top, 10)

                        Capsule_Button(title: "Update password") {
                            if password.isEmpty || confirmPassword.isEmpty {
                                alertMessage = "Password / Confirm Password cannot be empty!"
                                showAlert = true
                            } else if password != confirmPassword {
                                alertMessage = "Password / Confirm Password should be same"
                                showAlert = true
                            } else {
                                path.append(.login)
                            }

                            print("Update Password tapped")
                        }
                        .padding(.top, 30)
                        .padding([.leading, .trailing], 50)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationTitle("Update Password")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                }

                // 🔥 This now overlays the entire screen including nav bar
                if showAlert {
                    AlertView(
                        image: Image(systemName: "exclamationmark.circle.fill"),
                        title: "Alert",
                        message: alertMessage,
                        primaryButton: AlertButtonConfig(title: "OK", action: {
                            print("Primary button tapped")
                        }),
                        secondaryButton: AlertButtonConfig(title: "Cancel", action: {
                            print("Cancel tapped")
                        }),
                        dismiss: {
                            showAlert = false
                        }
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: showAlert)
                }
            }
    }
}


#Preview {
    struct NewPasswordScreenPreviewWrapper: View {
        @State private var path: [AppRoute] = []

        var body: some View {
            NavigationStack(path: $path) {
                NewPassword_Screen(path: $path)
            }
        }
    }

    return NewPasswordScreenPreviewWrapper()
}
