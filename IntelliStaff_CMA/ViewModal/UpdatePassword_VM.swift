//
//  UpdatePassword_VM.swift
//  IntelliStaff_EMA
//
//  Created by NFC Solutions on 10/09/25.
//

import Foundation

@MainActor
@Observable
class UpdatePasswordViewModel {
    var isLoading = false
    var errorMessage: String?
    
    func updatePassword(email: String, password: String, errorHandler: GlobalErrorHandler) async -> UpdatePasswordResponse? {
        isLoading = true
        defer { isLoading = false }
        
        let params: [String: Any] = ["requestsource": 6,
                                     "username": email,
                                     "usertype": 3,
                                     "password": password,
                                     "confirmpassword": password,
                                     "isPasswordChange": false]
        
        print("the update password params is", params)
        
        do {
            let response = try await APIFunction.updatePasswordAPICalling(params: params)
            print("the response for update password is", response)
            return response
        }
        catch let error as NetworkError {
            self.errorMessage = error.localizedDescription
            errorHandler.handleNetworkError(error)
            return nil
        } catch {
            self.errorMessage = error.localizedDescription
            errorHandler.showError(message: error.localizedDescription, mode: .alert)
            return nil
        }
    }
}
