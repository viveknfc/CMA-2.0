//
//  UnderlinedTF.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

struct UnderlinedTF: View {
    
    let title: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.titleFont)
                .foregroundColor(.gray)
            
            HStack {
                if isSecure && !isPasswordVisible {
                    SecureField("Enter \(title.lowercased())", text: $text)
                        .padding(.vertical, 4)
                        .font(.bodyFont)
                        .onChange(of: text) {
                            text = text.replacingOccurrences(of: " ", with: "")
                        }
                    
                } else {
                    TextField("Enter \(title.lowercased())", text: $text)
                        .padding(.vertical, 4)
                        .font(.bodyFont)
                        .onChange(of: text) {
                            text = text.replacingOccurrences(of: " ", with: "")
                        }
                    
                }
                
                // Show eye button only for secure fields
                if isSecure {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                    }
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    struct UnderlinePreviewWrapper: View {
        @State private var text = "Enter Name"

        var body: some View {
            UnderlinedTF(title: "User Name", text: $text)
                .padding()
        }
    }

    return UnderlinePreviewWrapper()
}


