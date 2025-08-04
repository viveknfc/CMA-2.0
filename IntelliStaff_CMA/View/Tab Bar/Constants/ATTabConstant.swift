//
//  ATTabConstant.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// A mode that defines the spacing between tab buttons.
public enum ATSpacingMode: Hashable {
    case center
    case average
}

/// Defines the shadow of the tab view.
public struct ATTabConstant: Equatable {
    
    public var normalSize: CGSize
    public var selectWidth: CGFloat
    public var spacingMode: ATSpacingMode
    public var spacing: CGFloat
    public var shadow: ATShadowConstant
    public var activeVibration: Bool
    public var transition: AnyTransition
    public var animation: Animation?
    
    /// Initializes `ATTabConstant`
    /// - Parameters:
    ///   - normalSize: The default size of the tab button.
    ///   - selectWidth: The horizontal size of the selected tab button. The default value is -1, and if it is -1, it is the same as the default size.
    ///   - spacingMode: A mode that defines the spacing between tab buttons.
    ///   - spacing: Spacing between tab buttons when spacingMode is `.center`.
    ///   - shadow: The shadow of the background of the tab view.
    ///   - activeVibration: Activate the device's vibration. Only iOS is supported.
    ///   - transition: A transition when a tab is selected.
    ///   - animation: Animation when selecting a tab.
    public init(normalSize: CGSize = CGSize(width: 40, height: 40), //80
                selectWidth: CGFloat = -1,
                spacingMode: ATSpacingMode = .average,
                spacing: CGFloat = 0,
                shadow: ATShadowConstant = .init(),
                activeVibration: Bool = true,
                transition: AnyTransition = .opacity,
                animation: Animation? = .easeInOut(duration: 0.28)) {
        self.normalSize = normalSize
        self.selectWidth = selectWidth
        self.spacingMode = spacingMode
        self.spacing = spacing
        self.shadow = shadow
        self.activeVibration = activeVibration
        self.transition = transition
        self.animation = animation
    }
    
    public static func == (lhs: ATTabConstant, rhs: ATTabConstant) -> Bool {
        lhs.normalSize == rhs.normalSize &&
        lhs.selectWidth == rhs.selectWidth &&
        lhs.spacingMode == rhs.spacingMode &&
        lhs.spacing == rhs.spacing &&
        lhs.shadow == rhs.shadow &&
        lhs.activeVibration == rhs.activeVibration &&
        lhs.animation == rhs.animation
    }
}
