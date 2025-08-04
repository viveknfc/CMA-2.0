//
//  GlobalErroHandler.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 19/07/25.
//
import SwiftUI

class GlobalErrorHandler: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var showToast: Bool = false
    @Published var showAlert: Bool = false

    var alertTitle: String? = "Oops!"
    var alertImage: Image? = nil
    var alertPrimaryButton: AlertButtonConfig = AlertButtonConfig(title: "OK", action: {})
    var alertSecondaryButton: AlertButtonConfig? = nil

    func showError(message: String,
                   mode: ErrorDisplayMode = .toast,
                   title: String? = nil,
                   image: Image? = nil,
                   primary: AlertButtonConfig? = nil,
                   secondary: AlertButtonConfig? = nil) {
        self.errorMessage = message

        switch mode {
        case .toast:
            showToast = true
            showAlert = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showToast = false
            }

        case .alert:
            self.alertTitle = title ?? "Oops!"
            self.alertImage = image
            self.alertPrimaryButton = primary ?? AlertButtonConfig(title: "OK", action: {})
            self.alertSecondaryButton = secondary
            self.showAlert = true
            self.showToast = false
        }
    }

    func dismissAlert() {
        showAlert = false
    }
}

extension GlobalErrorHandler {
    func handleNetworkError(_ error: NetworkError) {
        showError(
            message: error.localizedDescription,
            mode: error.displayMode
        )
    }
}

