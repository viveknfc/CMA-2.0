//
//  Login_VM.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 16/07/25.
//

import Foundation

@MainActor
@Observable
class LoginViewModel {
    
    var isLoading = false
    var errorMessage: String?
    var token: TokenResponse?
    var loginResponse: LoginResponse?
    var isLoginSuccess = false

    func fetchServiceToken(errorHandler: GlobalErrorHandler) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let token = try await APIFunction.serviceAuthAPICalling()
//            print("The token response is", token.accessToken)
            APIConstants.accessToken = token.accessToken
            self.token = token
        } catch let error as NetworkError {
            // Safely cast to your custom error type
            self.errorMessage = error.localizedDescription
            errorHandler.handleNetworkError(error)
        } catch {
            // For any unknown or unexpected error type
            self.errorMessage = error.localizedDescription
            errorHandler.showError(message: error.localizedDescription, mode: .alert)
        }
    }

    func login(username: String, password: String,errorHandler: GlobalErrorHandler) async -> LoginResponse?{
        isLoading = true
        defer { isLoading = false }

        let params: [String: Any] = [
            "login": username,
            "password": password,
            "requestsource": 3,
            "granttype": "password",
            "islifetime": true,
            "userid": 0,
            "refreshtoken": "",
            "usertype": 3
        ]
        
        print("the login params is", params)

        do {
            let response = try await APIFunction.loginAPICalling(params: params)
//            print("Login success: the response is \n \(response)")
            
            self.loginResponse = response
            self.isLoginSuccess = true
            // Handle navigation, token storage, etc.
            
            UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
            UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
            UserDefaults.standard.set(response.expiresIn, forKey: "expiresIn")
            UserDefaults.standard.set(username, forKey: "Username")
            UserDefaults.standard.set(password, forKey: "Password")
            
//            print("the response access tokem is \n \(response.accessToken)")
            
            if let userId = decodeUserIdFromJWT(response.accessToken ?? "") {
                UserDefaults.standard.set(userId, forKey: "userId")
                print("Decoded User ID: \(userId)")
            }
            
            return response
            
        } catch let error as NetworkError {
            self.errorMessage = error.localizedDescription
            errorHandler.showError(message: error.localizedDescription, mode: error.displayMode)
//            errorHandler.handleNetworkError(error)
            return nil
        } catch {
            self.errorMessage = error.localizedDescription
            errorHandler.showError(message: error.localizedDescription, mode: .alert)
            return nil
        }
    }

}

