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
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchProfileList() {
        let apiTitles = ["Employee Profile", "Change Password", "Settings", "Logout"]
        
        self.profileList = apiTitles.map { title in
            ProfileModel(title: title, imageName: imageForTitle(title))
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
