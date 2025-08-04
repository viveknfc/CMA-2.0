//
//  DivisionList_VM.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 04/08/25.
//

import Foundation

@MainActor
@Observable
class DivisionList_VM {
    
    var divisions: [DivisionList] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchDivisions() {
        Task {
            isLoading = true
            do {
                let userName = UserDefaults.standard.string(forKey: "Username") ?? ""
                let password = UserDefaults.standard.string(forKey: "Password") ?? ""
                
                let params: [String: String] = ["email": userName, "password": password]
                
                let result = try await APIFunction.divisionListAPICalling(params: params)
                print("the result of division list is: \(result)")
                
                self.divisions = result
                self.isLoading = false
            } catch {
                print("🔥 API Failed: \(error)")
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
