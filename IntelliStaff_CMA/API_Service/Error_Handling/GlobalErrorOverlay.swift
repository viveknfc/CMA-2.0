//
//  GlobalErrorOverlay.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 19/07/25.
//
import SwiftUI

struct GlobalErrorOverlay: ViewModifier {
    @EnvironmentObject var errorHandler: GlobalErrorHandler

    func body(content: Content) -> some View {
        ZStack {
            content

            if errorHandler.showToast {
                VStack {
                    Spacer()
                    Toast_View(message: errorHandler.errorMessage)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
            }

            if errorHandler.showAlert {
                AlertView(
                    image: Image(systemName: "exclamationmark.circle"),
                    title: "Oops!",
                    message: errorHandler.errorMessage,
                    primaryButton: AlertButtonConfig(title: "OK", action: {}),
                    secondaryButton: nil,
                    dismiss: {
                        errorHandler.showAlert = false
                    }
                )
                .transition(.opacity.combined(with: .scale))
                .zIndex(2)
            }
        }
    }
}

extension View {
    func withGlobalOverlay() -> some View {
        self.modifier(GlobalErrorOverlay())
    }
}

