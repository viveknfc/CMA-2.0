//
//  UserJson.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 05/08/25.
//

import Foundation

//struct WebViewPayload {
//    let currentUserJson: String
//    let keyGuard: String
//    let keyName: String
//}
//
//func buildWebViewPayload() -> WebViewPayload {
//    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
//    let expiresIn = UserDefaults.standard.integer(forKey: "expiresIn")
//    let password = UserDefaults.standard.string(forKey: "Password") ?? ""
//    let username = UserDefaults.standard.string(forKey: "Username") ?? ""
//
//    // Build JSON for currentUserEWA
//    let jsonObject: [String: Any] = [
//        "accessToken": accessToken,
//        "refreshToken": refreshToken,
//        "expiresIn": expiresIn,
//        "requestingPartyToken": "Bearer",
//        "message": "success",
//        "isPasswordChange": false,
//        "username": username
//    ]
//
//    let currentUserJson: String
//    if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
//       let jsonString = String(data: data, encoding: .utf8) {
//        currentUserJson = escapeForJavaScript("\"\(jsonString)\"")
//    } else {
//        currentUserJson = ""
//    }
//
//    return WebViewPayload(
//        currentUserJson: currentUserJson,
//        keyGuard: escapeForJavaScript(password),
//        keyName: escapeForJavaScript(username),
//    )
//}

struct WebViewPayload {
    let currentUserJson: String
    let keyGuard: String
    let keyName: String
    let accessToken: String
    var cwaDetails :[String:Any] = [:]
}

func buildWebViewPayload() -> WebViewPayload {
    let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    let expiresIn = UserDefaults.standard.integer(forKey: "expiresIn")
    let password = UserDefaults.standard.string(forKey: "Password") ?? ""
    let username = UserDefaults.standard.string(forKey: "Username") ?? ""

    // Build JSON for currentUserCWA
    let jsonObject: [String: Any] = [
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "expiresIn": expiresIn,
        "requestingPartyToken": "Bearer",
        "message": "success",
        "isPasswordChange": false,
        "username": username
    ]
    
//    var cwaDetails: [String: Any] = [:]
//    
//    if let clientId = userDefaults.string(forKey: "cmaClientId"), clientId != "null" {
//        cwaDetails["ClientId"] = Int(clientId)
//    }
//    if let divisionId = userDefaults.string(forKey: "cmaDivisionId"), divisionId != "null" {
//        cwaDetails["DivisionID"] = Int(divisionId)
//    }
//    cwaDetails["DivisionName"] = userDefaults.string(forKey: "cmaDivisionName") ?? ""
//    if let contactId = userDefaults.string(forKey: "cmaContactId"), contactId != "null" {
//        cwaDetails["ContactId"] = Int(contactId)
//    }
//    cwaDetails["displayName"] = userDefaults.string(forKey: "cmaName") ?? ""
//    cwaDetails["ClientName"] = userDefaults.string(forKey: "cmaClientName") ?? ""
//    cwaDetails["siteName"] = userDefaults.string(forKey: "cmaClientName") ?? ""
//    
//    if let master = userDefaults.string(forKey: "cmaMaster"), !master.isEmpty, let masterInt = Int(master) {
//        cwaDetails["Master"] = masterInt
//    }
//    
//    if let clientContactInfoId = userDefaults.string(forKey: "cmaClientContactInfoId"), clientContactInfoId != "null" {
//        cwaDetails["ClientContactInfoId"] = Int(clientContactInfoId)
//    }
//
    
    let fetched = UserDefaults.standard.dictionary(forKey: "cwaDetails")
    print(fetched)
    
    

    
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
        accessToken: escapeForJavaScript(accessToken), cwaDetails: fetched ?? [:]
    )
}

func makeCwaDictDetails(from division: DivisionList) -> [String: Any] {
    var dict: [String: Any] = [:]
    
    if let clientContactInfoId = division.clientContactInfoID {
        dict["ClientContactInfoId"] = clientContactInfoId
    }
    if let clientId = division.clientID {
        dict["ClientId"] = clientId
    }
    if let clientName = division.clientName {
        dict["ClientName"] = clientName
    }
    if let contactId = division.contactID {
        dict["ContactId"] = contactId
    }
    if let divisionId = division.divisionID {
        dict["DivisionID"] = divisionId
    }
    if let divisionName = division.divisionName {
        dict["DivisionName"] = divisionName
    }
    if let master = division.master {
        dict["Master"] = master
    }
    if let displayName = division.name {
        dict["displayName"] = displayName
    }
    if let siteName = division.name {
        dict["siteName"] = siteName
    }

    print(dict)
    return dict
}


//MARK: - For division List

func makeCwaDetails(from division: DivisionList) -> [String: Any] {
    var dict: [String: Any] = [:]
    
    if let clientId = division.clientID { dict["cmaClientId"] = clientId }
    if let divisionId = division.divisionID { dict["cmaDivisionId"] = divisionId }
    if let name = division.divisionName { dict["cmaDivisionName"] = name }
    if let contactId = division.contactID { dict["cmaContactId"] = contactId }
    if let displayName = division.name { dict["cmaName"] = displayName }
    if let clientName = division.clientName {
        dict["cmaClientName"] = clientName
        dict["cmaClientName"] = clientName
    }
    if let master = division.master { dict["cmaMaster"] = master }
    if let clientContactInfoId = division.clientContactInfoID {
        dict["cmaClientContactInfoId"] = clientContactInfoId
    }
   
    
    print(dict)
    
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
