
import SwiftUI

struct CurvedHeader: View {
    var rectHeight: CGFloat = 150   // height of the flat rectangle
    var curveHeight: CGFloat = 100  // depth of the curve
    
    var body: some View {
        VStack(spacing: 0) {
            CurvedRectangle(rectHeight: rectHeight, curveHeight: curveHeight)
                .fill(.theme)
            
            Spacer()
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct CurvedRectangle: Shape {
    var rectHeight: CGFloat
    var curveHeight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at top-left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        
        // Line down to bottom-left of rectangle part
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rectHeight))
        
        // Curve from bottom-left to bottom-right
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + rectHeight),
            control: CGPoint(x: rect.midX, y: rect.minY + rectHeight + curveHeight)
        )
        
        // Line back to top-right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        // Close the shape
        path.closeSubpath()
        
        return path
    }
}

struct HalfCurve_View: View {
    var body: some View {
        CurvedHeader(rectHeight: 200, curveHeight: 100)
    }
}

#Preview {
    HalfCurve_View()
}

