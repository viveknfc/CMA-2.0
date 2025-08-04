//
//  ATStateViewModel.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// A viewmodel that manages the current and previous values of the selected tab.
class ATStateViewModel<SelectionValue: Hashable>: ObservableObject {
    
    /// The tag of the previously selected tab.
    var previousSelection: SelectionValue? = nil
    
    /// An array of all tags.
    var tags: [SelectionValue] = []
    
    /// The index value of the previously selected tag.
    var previousIndex: Int {
        return indexOfTag(previousSelection)
    }
    
    /// Returns the position index of the tag.
    /// - Parameter tag: A tag that separates the tab view.
    /// - Returns: Returns the position index of the tag.
    func indexOfTag(_ tag: SelectionValue?) -> Int {
        return tags.firstIndex(where: {$0 == tag}) ?? 0
    }
}
