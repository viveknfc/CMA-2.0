//
//  View+Extension.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

public extension View {
    func tabItem<SelectionValue: Hashable,
                 N: View,
                 S: View>(tag: SelectionValue,
                          @ViewBuilder normal: @escaping () -> N,
                          @ViewBuilder select: @escaping () -> S) -> some View {
        modifier(ATTabItemModifier(tag: tag,
                                   normal: normal(),
                                   select: select()))
    }
}
