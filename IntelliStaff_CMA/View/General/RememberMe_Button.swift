//
//  RememberMe_Button.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

struct RememberMe_Button: View {
    @Binding var isSelected: Bool
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark.square" : "square")
                    .font(.system(size: 20)) // Increased size
                    .foregroundColor(isSelected ? .theme : .gray)
                Text("Remember Me")
                    .foregroundColor(.primary)
                    .font(.buttonFont)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling
    }
    
}

#Preview {
    struct RememberMeButtonPreviewWrapper: View {
        @State private var isSelected = false

        var body: some View {
            RememberMe_Button(isSelected: $isSelected)
                .padding()
        }
    }

    return RememberMeButtonPreviewWrapper()
}

