//
//  DivisionRow_View.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 04/08/25.
//

import SwiftUI

struct DivisionRow_View: View {
    let item: DivisionList

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image("notes")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.blue)

                Text(item.clientName ?? "")
                    .font(.buttonFont)

                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)

            Text(item.divisionName ?? "")
                .font(.bodyFont)
                .foregroundColor(.gray)
                .padding(.horizontal, 36)

            DottedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 8]))
                .foregroundColor(.gray)
                .frame(height: 1)
                .padding(.horizontal, 15)
                .padding(.bottom, 4)
        }
    }
}

#Preview {
    DivisionRow_View(item: DivisionList(
        clientName: "Apple Inc.",
        clientID: 1,
        contactID: 101,
        divisionName: "iOS Division",
        pendingTS: 0,
        divisionId: 1,
        showLogin: 1,
        showBreakminutes: 1,
        name: "John Appleseed",
        master: 1,
        clientContactInfoId: 10
    ))
}
