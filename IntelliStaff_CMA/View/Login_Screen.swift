//
//  Login_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

struct Login_Screen: View {
    
    @State private var viewModel = LoginViewModel()
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isForgotActive = false
    @State private var isLoginSuccess = false
    @Binding var path: [AppRoute]
    
    var body: some View {

            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                VStack {
                    
                    Image("Splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                    
                    Text("Hello there, login to continue")
                        .font(.titleFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        UnderlinedTF(title: "Username", text: $username)
                        UnderlinedTF(title: "Password", text: $password, isSecure: true)
                    }
                    .padding(.top, 10)
                    
                    Capsule_Button(title: "Submit") {
                        
                        UIApplication.shared.endEditing()
                        print("Submit tapped")
                        if username.isEmpty || password.isEmpty {
                            errorHandler.showError(message: "Please enter both username and password", mode: .toast)
                        } else {
                            Task {
                                if (await viewModel.login(username: username, password: password,errorHandler: errorHandler)) != nil {
                                    path.append(.divisionList)
                                }
                            }
                        }
                    }
                    .padding(.top, 40)
                    .padding([.leading, .trailing], 50)
                    
                    Button("Forgot password?") {
                        path.append(.forgotPassword)
                    }
                    .font(.buttonFont)
                    .padding(.top, 10)
                    
                }
                .padding(24)
                .navigationBarHidden(true)
                
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()

                    TriangleLoader()
                }
    
            }
            .task {
                await viewModel.fetchServiceToken(errorHandler: errorHandler)
            }

    }
}

#Preview {
    struct LoginScreenPreviewWrapper: View {
        @State private var path: [AppRoute] = []

        var body: some View {
            NavigationStack(path: $path) {
                Login_Screen(path: $path)
                    .environmentObject(GlobalErrorHandler())
            }
        }
    }

    return LoginScreenPreviewWrapper()
}

