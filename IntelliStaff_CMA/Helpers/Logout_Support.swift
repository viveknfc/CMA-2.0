//
//  Logout_Support.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 01/08/25.
//

import Foundation
import SwiftUI

struct SessionManager {
    static func performLogout(path: Binding<[AppRoute]>) {
        // Clear stored user info
        UserDefaults.standard.removeObject(forKey: "Username")
        UserDefaults.standard.removeObject(forKey: "Password")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "expiresIn")
        UserDefaults.standard.removeObject(forKey: "userId")
        
        print("cleared all userdeafulats")

        path.wrappedValue = []
        

    }
}





