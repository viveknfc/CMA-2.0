//
//  ATCurveStyle.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// Curve style for tab view.
public struct ATCurveStyle: ATBackgroundStyle {
    
    public var state: ATTabState
    public var color: Color = .white
    public var radius: CGFloat = 60
    public var depth: CGFloat = 0.95
    
    public init(_ state: ATTabState, color: Color, radius: CGFloat, depth: CGFloat) {
        self.state = state
        self.color = color
        self.radius = radius
        self.depth = depth
    }
    
    public var body: some View {
        let tabConstant = state.constant.tab
        GeometryReader { proxy in
            ATCurveShape(radius: radius, depth: depth, position: state.getCurrentDeltaX())
                .fill(color)
                .frame(height: tabConstant.normalSize.height  + (state.constant.axisMode == .bottom ? state.safeAreaInsets.bottom : state.safeAreaInsets.top))
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
        
        .animation(.easeInOut, value: state.currentIndex)
    }
}

struct ATCurveStyle_Previews: PreviewProvider {
   static var previews: some View {
       ATCurveStyle(ATTabState(), color: Color(hex: 0x1A4E56), radius: 60, depth: 0.90)
   }
}
