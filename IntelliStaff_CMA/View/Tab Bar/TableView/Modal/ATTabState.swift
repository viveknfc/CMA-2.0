//
//  ATTabState.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// The current state of the tab view.
public struct ATTabState {
    
    public var constant: ATConstant
    public var itemCount: Int
    public var previousIndex: Int
    public var currentIndex: Int
    public var size: CGSize
    public var safeAreaInsets: EdgeInsets
    
    /// The current state of the tab view.
    /// - Parameters:
    ///   - constant: Defines the settings for the tab view.
    ///   - itemCount: Total number of tab buttons.
    ///   - previousIndex: The previously selected position index value.
    ///   - currentIndex: The currently selected position index value.
    ///   - size: The full size of the tab view. This also includes the safe area.
    ///   - safeAreaInsets: The safe area of the tab view.
    public init(constant: ATConstant = .init(),
                itemCount: Int = 0,
                previousIndex: Int = 0,
                currentIndex: Int = 0,
                size: CGSize = .zero,
                safeAreaInsets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) {
        self.constant = constant
        self.itemCount = itemCount
        self.previousIndex = previousIndex
        self.currentIndex = currentIndex
        self.size = size
        self.safeAreaInsets = safeAreaInsets
    }
    
    /// Returns the position of the current tab.
    public func getCurrentX() -> CGFloat {
        let tabConstant = constant.tab
        var leadingPadding: CGFloat = 0
        
        let btnWidth: CGFloat = constant.tab.normalSize.width
        let selectBtnWidth: CGFloat = constant.tab.selectWidth > 0 ? constant.tab.selectWidth : btnWidth
        let btnAllWidth: CGFloat = constant.tab.normalSize.width * CGFloat(itemCount - 1) + selectBtnWidth
        
        let spaceAllWidth: CGFloat = size.width - btnAllWidth
        var spaceWidth: CGFloat = spaceAllWidth / CGFloat(itemCount + 1)
        
        if tabConstant.spacingMode == .center {
            spaceWidth = tabConstant.spacing
            let gap = size.width - (constant.tab.normalSize.width * CGFloat(itemCount) + (tabConstant.spacing * CGFloat(itemCount + 1)))
            leadingPadding = (gap * 0.5)
        }else {
            leadingPadding = (selectBtnWidth * 0.5 - btnWidth * 0.5)
        }
        return leadingPadding + ((spaceWidth + btnWidth) * CGFloat(currentIndex + 1) - btnWidth * 0.5) - selectBtnWidth * 0.5
    }
    
    /// Returns the percentage of the position of the current tab. A value between 0 and 1.
    public func getCurrentDeltaX() -> CGFloat {
        let selectBtnWidth: CGFloat = constant.tab.selectWidth > 0 ? constant.tab.selectWidth : constant.tab.normalSize.width
        return getCurrentX() / size.width + (selectBtnWidth * 0.5 / size.width)
    }
}
