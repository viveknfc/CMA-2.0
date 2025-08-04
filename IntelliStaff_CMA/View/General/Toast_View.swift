//
//  Toast_View.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

struct Toast_View: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.85))
            .cornerRadius(12)
            .padding(.horizontal, 20)
    }
}

#Preview {
    Toast_View(message: "There is an error")
}
