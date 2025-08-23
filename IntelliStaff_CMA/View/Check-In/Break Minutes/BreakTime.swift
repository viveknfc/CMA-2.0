//
//  BreakTime.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 23/08/25.
//

import SwiftUI

struct BreakTime: View {
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Button(action: action) {
                HStack {
                    Text(value)
                        .foregroundColor(.theme)
                        .font(.bodyFont)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(height: 30)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }
        }
    }
}

#Preview {
    BreakTime(title: "Start", value: "10:00") {
        print("Break")
    }
}
