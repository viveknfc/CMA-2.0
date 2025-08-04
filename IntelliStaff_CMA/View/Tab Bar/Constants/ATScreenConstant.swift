//
//  ATScreenConstant.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// The mode of the transition animation in the content view.
public enum ATTransitionMode: Hashable {
    case slide(CGFloat)
    case scale(CGFloat)
    case opacity
    case none
}

/// A constant for the content view.
public struct ATScreenConstant: Equatable {
    
    /// Activate the SafeArea area.
    public var activeSafeArea: Bool
    
    /// The mode of the transition animation in the content view.
    public var transitionMode: ATTransitionMode
    
    /// An animation of the content viewer.
    public var animation: Animation?
    
    /// Initializes `ATScreenConstant`
    /// - Parameters:
    ///   - activeSafeArea: Activate the SafeArea area.
    ///   - transitionMode: The mode of the transition animation in the content view.
    ///   - animation: An animation of the content viewer.
    public init(activeSafeArea: Bool = true,
                transitionMode: ATTransitionMode = .opacity,
                animation: Animation? = .easeInOut(duration: 0.28)) {
        self.activeSafeArea = activeSafeArea
        self.transitionMode = transitionMode
        self.animation = animation
    }
}
