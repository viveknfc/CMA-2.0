//
//  ATConstant.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// The position mode of the tab view.
public enum ATAxisMode: Hashable {
    case top
    case bottom
}

/// Defines the settings for the tab view.
public struct ATConstant: Equatable {
    
    public var axisMode: ATAxisMode
    public var screen: ATScreenConstant
    public var tab: ATTabConstant
    
    /// Initializes `ATConstant`
    /// - Parameters:
    ///   - axisMode: The position mode of the tab view.
    ///   - screen: The mode of the transition animation in the content view.
    ///   - tab: A mode that defines the spacing between tab buttons.
    public init(axisMode: ATAxisMode = .bottom,
                screen: ATScreenConstant = .init(),
                tab: ATTabConstant = .init()) {
        self.axisMode = axisMode
        self.screen = screen
        self.tab = tab
    }
}
