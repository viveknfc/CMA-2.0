//
//  ClientInfo.swift
//  IntelliStaff_CMA
//
//  Created by ios on 16/09/25.
//

import SwiftUI
import Foundation

struct ClientRepView: View {
    @StateObject private var viewModel = Client_VM()
    @Binding var path: [AppRoute]
    var clientID: Int
    var contactID: Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
            VStack(spacing: 0) {
                // Content
                VStack(spacing: 16) {
                    // Name Field - Fixed binding
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Name", text: Binding(
                            get: { viewModel.clientList?.name ?? "" },
                            set: { viewModel.clientList?.name = $0.isEmpty ? "" : $0 }
                        ))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    // Phone Field
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Phone", text: Binding(
                            get: { viewModel.clientList?.phone ?? "" },
                            set: { viewModel.clientList?.phone = $0.isEmpty ? "" : $0 }
                        ))
                            .keyboardType(.phonePad)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Email", text: Binding(
                            get: { viewModel.clientList?.addETo ?? "" },
                            set: { viewModel.clientList?.addETo = $0.isEmpty ? "" : $0 }
                        ))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle(" Your Client Rep")
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
           
        
        .onAppear {
            viewModel.fetchclient(clientId: String(clientID ?? 0), contactID:  String(contactID ?? 0), errorHandler: GlobalErrorHandler())
        }
    }
}

// Alternative approach using a computed property in your ViewModel:
// Add this to your Client_VM class:*
extension Client_VM {
    var nameBinding: Binding<String> {
        Binding(
            get: { self.clientList?.name ?? "" },
            set: { self.clientList?.name = $0.isEmpty ? "" : $0 }
        )
    }
}

// Then use it in your view like this:
//TextField("Name", text: viewModel.nameBinding)
//*/
struct ClientRepView_Previews: PreviewProvider {
    @State static var path: [AppRoute] = []

    static var previews: some View {
        NavigationStack {
            ClientRepView(
                path: $path,
                clientID: 123,     // mock client id
                contactID: 456    // mock contact id
            )
            .environmentObject(GlobalErrorHandler()) // if required
        }
    }
}
