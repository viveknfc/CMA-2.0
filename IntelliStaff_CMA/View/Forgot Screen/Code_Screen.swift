//
//  Code_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

struct Code_Screen: View {
    
    @State private var inputs: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusIndex: Int?
    private var verificationCode: String {
        inputs.joined()
    }
    @State private var canResend = true
    @State private var resendCountdown = 0
    @StateObject private var timerModel = ResendTimerModel()
    @State private var isNewPasActive = false
    @Environment(\.dismiss) var dismiss
    @Binding var path: [AppRoute]
    
    var email: String
    var code: String
    @State private var viewModel = Forget_VM()
    @State private var showAlert = false
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    
    var body: some View {

            ZStack {
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                VStack(spacing: 0) {
                    
                    // Consistent top image spacing
                    Image("Splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .padding(.top, 40)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Check your email")
                            .font(.titleFont)
                        
                        Text("Enter the 4-digit code that we have sent via email")
                            .font(.bodyFont)
                            .padding(.bottom, 8)
                        
                        HStack {
                               Spacer()
                               SixBoxInputView(inputs: $inputs, focusedIndex: _focusIndex)
                               Spacer()
                           }
                        
                        Capsule_Button(title: "Verify Code") {
                            
                            print("Verify code tapped")
                            
                            if verificationCode == code{
                                //viewModel.otpResponseObj?.code ?? "" {
                                path.append(.newPassword(email: email))
                            } else {
                                showAlert = true
                            }
  
                        }
                        .padding(.top, 18)
                        .padding([.leading, .trailing], 50)
                        
                        HStack {
                            Text("Haven't got the email yet?")
                                .font(.bodyFont)
                            Button(action: {
                                Task {
                                    await viewModel.fetchOTP(email: email, errorHandler: errorHandler)
                                }
                                
                                timerModel.start()
                            }) {
                                if timerModel.canResend {
                                    Text("Resend")
                                } else {
                                    Text("Resend in \(timerModel.countdown)s")
                                }
                            }
                            .disabled(!timerModel.canResend)
                            .foregroundStyle(.theme)
                            .font(.buttonFont)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 5)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationTitle("Verify Code")
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
                        message: "Wrong code entered. Please try again.",
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
    struct CodeScreenPreviewWrapper: View {
        @State private var path: [AppRoute] = []

        var body: some View {
            NavigationStack(path: $path) {
                Code_Screen(path: $path, email: "", code: "")
            }
        }
    }

    return CodeScreenPreviewWrapper()
}

