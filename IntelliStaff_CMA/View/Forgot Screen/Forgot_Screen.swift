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
                        .padding(.top, 40)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Forgot Password")
                            .font(.titleFont)
                        
                        Text("Please enter your email to reset the password")
                            .font(.bodyFont)
                        
                        UnderlinedTF(title: "Email", text: $email)
                            .padding(.top, 10)
                        
                        Capsule_Button(title: "Reset password") {
                            path.append(.codeScreen)
                            print("Reset Password tapped")
                        }
                        .padding(.top, 30)
                        .padding([.leading, .trailing], 50)
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


