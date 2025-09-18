//
//  ATCurveStyle.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// Curve style for tab view.
//public struct ATCurveStyle: ATBackgroundStyle {
//    
//    public var state: ATTabState
//    public var color: Color = .white
//    public var radius: CGFloat = 60
//    public var depth: CGFloat = 0.95
//    
//    public init(_ state: ATTabState, color: Color, radius: CGFloat, depth: CGFloat) {
//        self.state = state
//        self.color = color
//        self.radius = radius
//        self.depth = depth
//    }
//    
//    public var body: some View {
//        let tabConstant = state.constant.tab
//        GeometryReader { proxy in
//            ATCurveShape(radius: radius, depth: depth, position: state.getCurrentDeltaX())
//                .fill(color)
//                .frame(height: tabConstant.normalSize.height  + (state.constant.axisMode == .bottom ? state.safeAreaInsets.bottom : state.safeAreaInsets.top))
//                .scaleEffect(CGSize(width: 1, height: state.constant.axisMode == .bottom ? 1 : -1))
//                .mask(
//                    Rectangle()
//                        .frame(height: proxy.size.height)
//                )
//                .shadow(color: tabConstant.shadow.color,
//                        radius: tabConstant.shadow.radius,
//                        x: tabConstant.shadow.x,
//                        y: tabConstant.shadow.y)
//            
//        }
//        
//        .animation(.easeInOut, value: state.currentIndex)
//    }
//}
//
//struct ATCurveStyle_Previews: PreviewProvider {
//   static var previews: some View {
//       ATCurveStyle(ATTabState(), color: Color(hex: 0x1A4E56), radius: 60, depth: 0.90)
//   }
//}
public struct ATFlatStyle: ATBackgroundStyle {
    
    public var state: ATTabState
    public var color: Color = .white
    public var cornerRadius: CGFloat = 0 // Changed from radius to cornerRadius for clarity
    public var showShadow: Bool = true
    
    public init(_ state: ATTabState, color: Color, cornerRadius: CGFloat = 0, showShadow: Bool = true) {
        self.state = state
        self.color = color
        self.cornerRadius = cornerRadius
        self.showShadow = showShadow
    }
    
    public var body: some View {
        let tabConstant = state.constant.tab
        GeometryReader { proxy in
            // Simple flat rectangle instead of curved shape
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
                .frame(height: tabConstant.normalSize.height + (state.constant.axisMode == .bottom ? state.safeAreaInsets.bottom : state.safeAreaInsets.top))
                .scaleEffect(CGSize(width: 1, height: state.constant.axisMode == .bottom ? 1 : -1))
                .mask(
                    Rectangle()
                        .frame(height: proxy.size.height)
                )
                .shadow(
                    color: showShadow ? (tabConstant.shadow.color.opacity(0.1)) : .clear,
                    radius: showShadow ? 2 : 0,
                    x: 0,
                    y: state.constant.axisMode == .bottom ? -1 : 1
                )
        }
        // Remove animation for static flat appearance
        // .animation(.easeInOut, value: state.currentIndex)
    }
}

// Alternative: Keep the same name but modify the implementation
public struct ATCurveStyle: ATBackgroundStyle {
    
    public var state: ATTabState
    public var color: Color = .white
    public var radius: CGFloat = 0 // Set to 0 for flat design
    public var depth: CGFloat = 0 // Set to 0 for flat design
    public var isFlat: Bool = true // Add flag to control flat vs curved
    
    public init(_ state: ATTabState, color: Color, radius: CGFloat, depth: CGFloat, isFlat: Bool = true) {
        self.state = state
        self.color = color
        self.radius = isFlat ? 0 : radius
        self.depth = isFlat ? 0 : depth
        self.isFlat = isFlat
    }
    
    public var body: some View {
        let tabConstant = state.constant.tab
        GeometryReader { proxy in
            if isFlat {
                // Flat design - simple rectangle
                Rectangle()
                    .fill(color)
                    .frame(height: tabConstant.normalSize.height + (state.constant.axisMode == .bottom ? state.safeAreaInsets.bottom : state.safeAreaInsets.top))
                    .mask(
                        Rectangle()
                            .frame(height: proxy.size.height)
                    )
                    .shadow(
                        color: tabConstant.shadow.color.opacity(0.1),
                        radius: 2,
                        x: 0,
                        y: state.constant.axisMode == .bottom ? -1 : 1
                    )
            } else {
                // Original curved design
                ATCurveShape(radius: radius, depth: depth, position: state.getCurrentDeltaX())
                    .fill(color)
                    .frame(height: tabConstant.normalSize.height + (state.constant.axisMode == .bottom ? state.safeAreaInsets.bottom : state.safeAreaInsets.top))
                    .scaleEffect(CGSize(width: 1, height: state.constant.axisMode == .bottom ? 1 : -1))
                    .mask(
                        Rectangle()
                            .frame(height: proxy.size.height)
                    )
                    .shadow(color: tabConstant.shadow.color,
                            radius: tabConstant.shadow.radius,
                            x: tabConstant.shadow.x,
                            y: tabConstant.shadow.y)
            }
        }
        .animation(isFlat ? nil : .easeInOut, value: state.currentIndex)
    }
}

struct ATCurveStyle_Previews: PreviewProvider {
   static var previews: some View {
       // Flat style preview
       ATCurveStyle(ATTabState(), color: Color(hex: 0x1A4E56), radius: 0, depth: 0, isFlat: true)
   }
}

// MARK: - Usage Examples

// Example 1: Using the new ATFlatStyle
struct ExampleFlatTabView: View {
    @State private var tabState = ATTabState()
    
    var body: some View {
        // Use ATFlatStyle instead of ATCurveStyle
        ATFlatStyle(tabState, color: .white, cornerRadius: 0, showShadow: true)
    }
}

// Example 2: Using modified ATCurveStyle with flat flag
struct ExampleModifiedTabView: View {
    @State private var tabState = ATTabState()
    
    var body: some View {
        // Use existing ATCurveStyle but with flat parameters
        ATCurveStyle(tabState, color: .white, radius: 0, depth: 0, isFlat: true)
    }
}

// MARK: - Helper Extensions (if Color(hex:) doesn't exist)
