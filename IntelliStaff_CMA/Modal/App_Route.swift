//
//  App_ROute.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 20/07/25.
//

import SwiftUICore

enum AppRoute: Hashable {
    case login
    case forgotPassword
    case codeScreen
    case newPassword
    case divisionList
    case dashboard(division: DivisionList)
    case webView(apiKey: String, division: DivisionList)
}

// AppRoute+ViewFactory.swift
extension AppRoute {
    @MainActor @ViewBuilder
    func destinationView(path: Binding<[AppRoute]>) -> some View {
        switch self {
        case .login:
            Login_Screen(path: path)
        case .forgotPassword:
            Forgot_Screen(path: path)
        case .codeScreen:
            Code_Screen(path: path)
        case .newPassword:
            NewPassword_Screen(path: path)
        case .divisionList:
            DivisionList_View(path: path, viewModal: DivisionList_VM())
        case .dashboard(let division):
            DashboardWrapper_View(division: division, path: path)
        case .webView(let apiKey, let division):
            WebView_Screen(urlKey: apiKey, division: division)
        }
    }
}

