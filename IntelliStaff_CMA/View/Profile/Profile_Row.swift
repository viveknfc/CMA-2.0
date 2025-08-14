//
//  Profile_Row.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 12/08/25.
//

import SwiftUI

struct Profile_Row: View {
    
    let item: ProfileModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: item.imageName)
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.black)

                Text(item.title)
                    .font(.buttonFont)

                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)

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
    Profile_Row(item: ProfileModel(title: "Settings", imageName: "person.circle"))
}
