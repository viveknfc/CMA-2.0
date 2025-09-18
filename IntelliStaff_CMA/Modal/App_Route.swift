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
    case codeScreen(email: String, otpResponse: String)
    case newPassword(email: String)
    case divisionList
    case dashboard(division: DivisionList)
  //  case webView(apiKey: String, division: DivisionList)
    case webView(apiKey: String)
    case clientRep(clientId: Int, contactId: Int)
}

// AppRoute+ViewFactory.swift
extension AppRoute {
    @MainActor @ViewBuilder
   // func destinationView(path: Binding<[AppRoute]>) -> some View {
    func destinationView(path: Binding<[AppRoute]>, dashboardViewModel: DashboardViewModel) -> some View {
        switch self {
        case .login:
            Login_Screen(path: path)
        case .forgotPassword:
            Forgot_Screen(path: path)
        case .codeScreen(let email, let otp):
            Code_Screen(path: path, email: email, code: otp)
        case .newPassword(let email):
            NewPassword_Screen(path: path, email: email)
        case .divisionList:
            DivisionList_View(path: path, viewModal: DivisionList_VM())
        case .dashboard(let division):
            DashboardWrapper_View(division: division, path: path)
        case .webView(let apiKey):
            WebView_Screen(urlKey: apiKey, viewModel: dashboardViewModel)
//        case .webView(let apiKey, let division):
//            WebView_Screen(urlKey: apiKey, division: division)
        case .clientRep(let clientId, let contactId):
            ClientRepView(path: path, clientID: Int(clientId) ?? 0, contactID:  Int(contactId) ?? 0)
        }
    }
}

