//
//  UserJson.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 05/08/25.
//

import Foundation

struct WebViewPayload {
    let currentUserJson: String
    let keyGuard: String
    let keyName: String
}

func buildWebViewPayload() -> WebViewPayload {
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    let expiresIn = UserDefaults.standard.integer(forKey: "expiresIn")
    let password = UserDefaults.standard.string(forKey: "Password") ?? ""
    let username = UserDefaults.standard.string(forKey: "Username") ?? ""

    // Build JSON for currentUserEWA
    let jsonObject: [String: Any] = [
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "expiresIn": expiresIn,
        "requestingPartyToken": "Bearer",
        "message": "success",
        "isPasswordChange": false,
        "username": username
    ]

    let currentUserJson: String
    if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
       let jsonString = String(data: data, encoding: .utf8) {
        currentUserJson = escapeForJavaScript("\"\(jsonString)\"")
    } else {
        currentUserJson = ""
    }

    return WebViewPayload(
        currentUserJson: currentUserJson,
        keyGuard: escapeForJavaScript(password),
        keyName: escapeForJavaScript(username),
    )
}

//MARK: - For division List

func makeCwaDetails(from division: DivisionList) -> [String: Any] {
    var dict: [String: Any] = [:]
    
    if let clientId = division.clientID { dict["ClientId"] = clientId }
    if let divisionId = division.divisionId { dict["DivisionID"] = divisionId }
    if let name = division.divisionName { dict["DivisionName"] = name }
    if let contactId = division.contactID { dict["ContactId"] = contactId }
    if let displayName = division.name { dict["displayName"] = displayName }
    if let clientName = division.clientName {
        dict["ClientName"] = clientName
        dict["siteName"] = clientName
    }
    if let master = division.master { dict["Master"] = master }
    if let clientContactInfoId = division.clientContactInfoId {
        dict["ClientContactInfoId"] = clientContactInfoId
    }
    
    return dict
}

func makeEscapedCwaDetailsString(from division: DivisionList) -> String {
    let details = makeCwaDetails(from: division)
    
    guard let data = try? JSONSerialization.data(withJSONObject: details, options: []),
          let jsonString = String(data: data, encoding: .utf8) else {
        return "{}"
    }

    return escapeForJavaScript(jsonString)
}

//END
