//
//  HalfCurve_View.swift
//  IntelliStaff_CMA
//
//  Created by ios on 01/10/25.
//

//
//  HalfCurve_View.swift
//  IntelliStaff_EMA
//
//  Created by NFC Solutions on 29/09/25.
//

import SwiftUI

struct CurvedHeader: View {
    var rectHeight: CGFloat = 150
    var curveHeight: CGFloat = 100
    var imageURL: String = ""
    var clientName: String = "Client Name"
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                CurvedRectangle(rectHeight: rectHeight, curveHeight: curveHeight)
                    .fill(.theme)
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            // Profile image and name positioned at top left
            HStack(spacing: 12) {
                // Profile Image
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                ProgressView()
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    case .failure:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(radius: 5)
                
                // Client Name
                VStack(alignment: .leading, spacing: 4) {
                    Text(clientName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, -20)
        }
    }
}

struct CurvedRectangle: Shape {
    var rectHeight: CGFloat
    var curveHeight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rectHeight))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + rectHeight),
            control: CGPoint(x: rect.midX, y: rect.minY + rectHeight + curveHeight)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}

struct HalfCurve_View: View {
    var body: some View {
        CurvedHeader(
            rectHeight: 200,
            curveHeight: 100,
            imageURL: "https://picsum.photos/200",
            clientName: "CCBQ Family Stabilization"
        )
    }
}

#Preview {
    HalfCurve_View()
}
