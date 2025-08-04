//
//  ATViewModel.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

/// A view model that manages the currently selected tab and constant values.
class ATViewModel<SelectionValue: Hashable>: ObservableObject {
    
    /// The currently selected tap value.
    @Binding var selection: SelectionValue
    
    /// A constant value for tab view.
    let constant: ATConstant
    
    /// Initializes `ATViewModel`
    /// - Parameters:
    ///   - selection: The currently selected tap value.
    ///   - constant: A constant value for tab view.
    init(selection: Binding<SelectionValue>, constant: ATConstant) {
        _selection = selection
        self.constant = constant
    }
}
