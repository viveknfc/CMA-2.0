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
    @State private var rememberMe: Bool = false
    @State private var hasLoadedOnce = false
    @AppStorage("isRemembered") private var isRemembered = false
    
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
                        .frame(width: 250, height: 125)
                    
                    Text("Hello there, login to continue")
                        .font(.titleFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                    
                    VStack(spacing: 20) {
                        UnderlinedTF(title: "Username", text: $username)
                        UnderlinedTF(title: "Password", text: $password, isSecure: true)
                    }
                    .padding(.top, 10)
                    
                    HStack {
                        RememberMe_Button(isSelected: $rememberMe)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Capsule_Button(title: "Submit") {
                        

                        
                        UIApplication.shared.endEditing()
                        print("Submit tapped")
                        if username.isEmpty || password.isEmpty {
                            errorHandler.showError(message: "Please enter both username and password", mode: .toast)
                        } else {
                            Task {
                                if (await viewModel.login(username: username, password: password, rememberMe: rememberMe,errorHandler: errorHandler)) != nil {
                                    path.append(.divisionList)
                                }
                            }
                        }
                    }
                    .padding(.top, 40)
                    .padding([.leading, .trailing], 0)
                    
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
                
                guard !hasLoadedOnce else { return }
                hasLoadedOnce = true
                
              //  await viewModel.fetchServiceToken(errorHandler: errorHandler) // Auto call when screen appears
                
                // 2. Auto-login if remembered
                if UserDefaults.standard.bool(forKey: "isRemembered") {
                    let savedUsername = UserDefaults.standard.string(forKey: "savedUsername") ?? ""
                    let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") ?? ""

                    if !savedUsername.isEmpty && !savedPassword.isEmpty {

                        if (await viewModel.login(
                            username: savedUsername,
                            password: savedPassword,
                            rememberMe: true,
                            errorHandler: errorHandler
                        )) != nil {
                            path.append(.divisionList)
                        }
                    }
                }
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

extension Array where Element == AppRoute {
    func containsDivisionList() -> Bool {
        return self.contains { route in
            if case .divisionList = route { return true }
            return false
        }
    }
}
