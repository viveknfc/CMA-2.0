//
//  ATTabItemModifier.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import SwiftUI

struct ATTabItemPreferenceKey: PreferenceKey {
    
    typealias Value = [ATTabItem]
    static var defaultValue: [ATTabItem] = []
    static func reduce(value: inout [ATTabItem], nextValue: () -> [ATTabItem]) {
        value.append(contentsOf: nextValue())
    }
}

struct ATTabItemModifier<SelectionValue: Hashable, N: View, S: View>: ViewModifier {
    
    @EnvironmentObject var viewModel: ATViewModel<SelectionValue>
    @EnvironmentObject var stateViewModel: ATStateViewModel<SelectionValue>
    
    /// A tag that separates the tab view.
    var tag: SelectionValue
    
    /// The tab button view in the unselected state.
    var normal: N
    
    /// The tab button view in the selected state.
    var select: S
    
    /// Handle transition animations in the content view.
    private var transition: AnyTransition {
        switch viewModel.constant.screen.transitionMode {
        case .slide(let x): return .asymmetric(insertion: .offset(x: (stateViewModel.previousIndex < stateViewModel.indexOfTag(viewModel.selection) ? x : -x)).combined(with: .opacity), removal: .opacity)
        case .scale(let scale): return .asymmetric(insertion: .scale(scale: stateViewModel.previousSelection == nil ? 1 : scale).combined(with: .opacity), removal: .opacity)
        case .opacity: return .opacity
        case .none: return .identity
        }
    }
    
    func body(content: Content) -> some View {
        let item = ATTabItem(tag: tag, normal: AnyView(normal), select: AnyView(select))
        ZStack {
            if tag == viewModel.selection {
                content
                    .transition(transition)
                    .onAppear {
                        self.stateViewModel.previousSelection = tag
                    }
            } else {
                EmptyView()
            }
        }
        .animation(viewModel.constant.screen.animation ?? .none, value: viewModel.selection)
        .preference(key: ATTabItemPreferenceKey.self, value: [item])
    }
}
