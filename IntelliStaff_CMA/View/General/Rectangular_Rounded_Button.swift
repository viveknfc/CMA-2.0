//
//  Rectangular_Rounded_Button.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import SwiftUI

struct Rectangular_Rounded_Button: View {
    var title: String
    var height: CGFloat = 30
    var action: () -> Void

   
    var backgroundColor: Color = .white
    var textColor: Color = .theme
    var font: Font = .bodyFont
    var cornerRadius: CGFloat = 8
    
    var borderColor: Color = .theme
    var borderWidth: CGFloat = 1
    
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, minHeight: height)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isPressed ? Color.gray.opacity(0.2) : backgroundColor)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                )
                .overlay( // Add outer border
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .opacity(isPressed ? 0.9 : 1.0)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    Rectangular_Rounded_Button(title: "Hii") {
        print("button pressed")
    }
}
