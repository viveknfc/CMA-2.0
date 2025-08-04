//
//  Code_Screen.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

struct Code_Screen: View {
    
    @State private var inputs: [String] = Array(repeating: "", count: 4)
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
                               FourBoxInputView(inputs: $inputs, focusedIndex: _focusIndex)
                               Spacer()
                           }
                        
                        Capsule_Button(title: "Verify Code") {
                            path.append(.newPassword)
                            print("Verify code tapped")
                        }
                        .padding(.top, 18)
                        .padding([.leading, .trailing], 50)
                        
                        HStack {
                            Text("Haven't got the email yet?")
                                .font(.bodyFont)
                            Button(action: {
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
            }

    }
}

#Preview {
    struct CodeScreenPreviewWrapper: View {
        @State private var path: [AppRoute] = []

        var body: some View {
            NavigationStack(path: $path) {
                Code_Screen(path: $path)
            }
        }
    }

    return CodeScreenPreviewWrapper()
}

