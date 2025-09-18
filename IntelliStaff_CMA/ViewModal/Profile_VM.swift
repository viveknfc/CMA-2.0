//
//  Profile_VM.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 12/08/25.
//
import Foundation

@MainActor
@Observable
class ProfileList_VM {
    
    var profileList: [ProfileModel] = []
    var vendorList: SubVendorResponse?
    var isLoading: Bool = false
    var errorMessage: String?
    
//    func fetchProfileList() {
//        let apiTitles = ["Employee Profile", "Change Password", "Settings", "Logout"]
//        
//        self.profileList = apiTitles.map { title in
//            ProfileModel(title: title, imageName: imageForTitle(title))
//        }
//    }
    
     func getMenuItems() -> [ProfileModel] {
           var listItems: [ProfileModel] = []
        let isSubVendor = vendorList
           
           listItems.append(ProfileModel(title: "Edit Your Information", imageName: "person.circle"))
           
        if isSubVendor?.isSubVendor == 0 {
               // CWA → add extra items
               listItems.append(ProfileModel(title: "Verify Billing Information", imageName: "arrow.backward.circle"))
               listItems.append(ProfileModel(title: "Your Client Rep", imageName: "questionmark.circle"))
           }
           
           // common items for both PWA and CWA
           listItems.append(ProfileModel(title: "Change Password", imageName: "key"))
           listItems.append(ProfileModel(title: "Logout", imageName: "arrow.backward.circle"))
         profileList.removeAll()
         profileList = listItems
           return profileList
       }
    
    
    func fetchSubVendor(
        clientId: String,
        errorHandler: GlobalErrorHandler
    ) {
        Task {
            isLoading = true
            let params: [String: Any] = ["clientId": clientId]
            do {
                let response = try await APIFunction.subVendorAPICalling(params: params)
                print("the response for subVendor is", response)
                vendorList = response
                isLoading = false
                getMenuItems()
            } catch let error as NetworkError {
                self.errorMessage = error.localizedDescription
                errorHandler.handleNetworkError(error)
                isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                errorHandler.showError(message: error.localizedDescription, mode: .alert)
                isLoading = false
            }
            isLoading = false
        }
        
        
        
    }


    
    
    
    
    private func imageForTitle(_ title: String) -> String {
        switch title {
        case "Employee Profile": return "person.circle"
        case "Change Password":  return "key"
        case "Settings":         return "gearshape"
        case "Logout":           return "arrow.backward.circle"
        default:                 return "questionmark.circle"
        }
    }
    
}
