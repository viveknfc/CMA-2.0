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
        VStack(spacing: 8) {
            // Image inside a box
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 0.5) // Border
                    .background(Color.white) // Fill
                    //.cornerRadius(10)
                    .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)

                Image(systemName: assignment.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.theme)
            }
            .frame(width: 90, height: 90) // square box size

            // Title below the box
            Text(assignment.title)
                .font(.menuFont)
//                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .lineLimit(2)
                .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
    }
}



#Preview {
    let sampleChildren = [
        ChildItem(name: "Algebra", imageName: "banknote", apiKey: "link"),
        ChildItem(name: "Geometry", imageName: "banknote", apiKey: "link"),
        ChildItem(name: "Trigonometry", imageName: "banknote", apiKey: "link")
    ]
    let menu = Dashboard_Menu_Items(title: "Math", imageName: "book.closed", itemCount: 4, children: sampleChildren)
    Dashboard_Menu_Card(assignment: menu)
}
