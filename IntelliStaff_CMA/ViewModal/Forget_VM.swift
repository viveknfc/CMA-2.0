//
//  Forget_VM.swift
//  IntelliStaff_CMA
//
//  Created by ios on 10/09/25.
//

import Foundation

@MainActor
@Observable
class Forget_VM {
    var otpResponseObj: SendOTPResponse?
    var isLoading: Bool = false
    var errorMessage: String?
    var otpCode: String?
    
    func fetchOTP(email: String, errorHandler: GlobalErrorHandler) async -> SendOTPResponse? {
        isLoading = true
        defer { isLoading = false }
        
        let params: [String: Any] = [
            "requestsource": 6,
            "username": email,
            "usertype": 3
        ]
        
        print("the Forgot otp params is", params)
        
        do {
            let response = try await APIFunction.sendOTPAPICalling(params: params)
            print("the response for forgot otp is", response)
            otpResponseObj = nil
            otpResponseObj = response
            otpCode = response.code
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
