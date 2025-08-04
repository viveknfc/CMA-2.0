//
//  Capsule_Button.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

struct Capsule_Button: View {
    var title: String
    var action: () -> Void

    // Optional customizations
    var width: CGFloat? = nil
    var height: CGFloat = 50
    var backgroundColor: Color = .theme
    var textColor: Color = .white
    var font: Font = .buttonFont

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundColor(textColor)
                .frame(maxWidth: width ?? .infinity, minHeight: height)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    Capsule_Button(title: "Submit") {
    }
}
