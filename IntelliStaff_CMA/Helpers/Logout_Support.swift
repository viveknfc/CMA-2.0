//
//  Logout_Support.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 01/08/25.
//

import Foundation

struct SessionManager {
    static func performLogout(path: inout [AppRoute]) {
        UserDefaults.standard.removeObject(forKey: "Username")
        UserDefaults.standard.removeObject(forKey: "Password")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "expiresIn")
        UserDefaults.standard.removeObject(forKey: "userId")
        path = [.login]
    }
}



