//
//  Forgot_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

struct Forgot_Screen: View {
    
    @State private var email: String = ""
    @State private var isCodeActive = false
    @Environment(\.dismiss) var dismiss
    @Binding var path: [AppRoute]
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    @State private var viewModel = Forget_VM()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {

            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                VStack {
                    
                    Image("CMA icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .padding(.top, 40)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Forgot Password")
                            .font(.titleFont)
                        
                        Text("Please enter your email to reset the password")
                            .font(.bodyFont)
                        
                        UnderlinedTF(title: "Email", text: $email)
                            .padding(.top, 10)
                        
                        Capsule_Button(title: "Submit") {
                            UIApplication.shared.endEditing()
                            print("Reset Password tapped")
                            if email.isEmpty {
                                errorHandler.showError(message: "Please enter email", mode: .toast)
                            } else {
                                Task {
                                let result = await viewModel.fetchOTP(email: email, errorHandler: errorHandler)
                                if let response = result {
                                    if response.code != nil {
                                        path.append(.codeScreen(email: email, otpResponse: response.code))
                                    } else {
                                        alertMessage = response.message ?? "Something went wrong"
                                    }
                                    
                                    }
                                }
                            }
                        }
                        .padding(.top, 30)
                        .padding([.leading, .trailing], 0)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationTitle("Forgot Password")
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
                
                if showAlert {
                    AlertView(
                        title: "Alert",
                        message: alertMessage,
                        primaryButton: AlertButtonConfig(title: "Ok", action: {
                            showAlert = false
                        }),
                        dismiss: {
                            showAlert = false
                        }
                    )
                    .transition(.opacity)
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()

                    TriangleLoader()
                }
                
            }
            
    }
}

#Preview {
    struct ForgotScreenPreviewWrapper: View {
        @State private var path: [AppRoute] = []

        var body: some View {
            NavigationStack(path: $path) {
                Forgot_Screen(path: $path)
            }
        }
    }

    return ForgotScreenPreviewWrapper()
}


