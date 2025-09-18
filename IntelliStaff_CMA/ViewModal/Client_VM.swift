//
//  Client_VM.swift
//  IntelliStaff_CMA
//
//  Created by ios on 16/09/25.
//

import Foundation


@MainActor
class Client_VM: ObservableObject {
    @Published var clientList: ClientResponse?
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchclient(
        clientId: String, contactID: String,
        errorHandler: GlobalErrorHandler
    ) {
        Task {
            isLoading = true
            let params: [String: Any] = ["clientId": clientId, "ContactId": contactID]
            do {
                let response = try await APIFunction.clientAPICalling(params: params)
                print("the response for subVendor is", response)
                clientList = response
                isLoading = false
            } catch let error as NetworkError {
                self.errorMessage = error.localizedDescription
                errorHandler.handleNetworkError(error)
                isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                errorHandler.showError(message: error.localizedDescription, mode: .alert)
                isLoading = false
            }
        }
    }
}

