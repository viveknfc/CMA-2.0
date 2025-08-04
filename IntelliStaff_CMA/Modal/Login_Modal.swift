//
//  Login_Modal.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 16/07/25.
//

import Foundation

//MARK: - Token Response

struct TokenResponse: Decodable {
    let accessToken: String
}

//MARK: - Login Response

struct LoginResponse: Decodable, Hashable {
    let isPasswordChange: Bool
    let expiresIn: Int
    let refreshToken: String
    let accessToken: String
    let requestingPartyToken: String
    let message: String
    let username: String
}

