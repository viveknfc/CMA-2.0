//
//  ATShadowConstant.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// Defines the shadow of the tab view.
public struct ATShadowConstant: Equatable {
    
    public var color: Color
    public var radius: CGFloat
    public var x: CGFloat
    public var y: CGFloat
    
    /// Initializes `ATShadowConstant`
    /// - Parameters:
    ///   - color: The shadow's color. The default value is `.black.opacity(0.3)`.
    ///   - radius: The shadow's size. The default value is `3`.
    ///   - x: A horizontal offset you use to position the shadow relative to the tab view. The default value is `0`.
    ///   - y: A vertical offset you use to position the shadow relative to the tab view. The default value is `0`.
    public init(color: Color = .black.opacity(0.35),
                radius: CGFloat = 3,
                x: CGFloat = 0,
                y: CGFloat = 0) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}
