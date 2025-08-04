//
//  ATBackgroundStyle.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI


/// The protocol that defines the backgroundstyle of the tab view.
public protocol ATBackgroundStyle: View {
    
    /// The current state of the tab view.
    var state: ATTabState { get }
    
}
