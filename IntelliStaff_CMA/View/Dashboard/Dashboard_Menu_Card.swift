//
//  Dashboard_Menu_Card.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 20/07/25.
//

import SwiftUI

struct Dashboard_Menu_Card: View {
    let assignment: Dashboard_Menu_Items

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 8) {
                Image(systemName: assignment.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.theme)
                    .padding(.top, 12)

                Text(assignment.title)
                    .font(.bodyFont)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.theme)
                    .padding([.horizontal, .bottom, .top], 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fill) // ✅ Makes square
            .overlay(
                         RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme, lineWidth: 0.5) // Stroke border only
                     )
            .background(Color.clear)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)

            // Badge
            if assignment.itemCount > 0 {
                Text("\(assignment.itemCount)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(.theme)
                    .clipShape(Circle())
                    .offset(x: -8, y: 8)
            }
        }
    }
}


#Preview {
    let sampleChildren = [
        ChildItem(name: "Algebra", apiKey: "link"),
        ChildItem(name: "Geometry", apiKey: "link"),
        ChildItem(name: "Trigonometry", apiKey: "link")
    ]
    let menu = Dashboard_Menu_Items(id: 123, title: "Math", imageName: "book.closed", itemCount: 4, children: sampleChildren)
    Dashboard_Menu_Card(assignment: menu)
}
