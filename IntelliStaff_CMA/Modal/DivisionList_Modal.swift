//
//  DivisionList_Modal.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 04/08/25.
//

import Foundation

struct DivisionList: Codable, Identifiable, Hashable {
    var id: Int {
        contactID ?? -1  // or use a fallback like clientID or throw fatalError if you must
    }
    
    let clientName: String?
    let clientID: Int?
    let contactID: Int?
    let divisionName: String?
    let pendingTS: Int?
    let divisionId: Int?
    let showLogin: Int?
    let showBreakminutes: Int?
    let name: String?
    let master: Int?
    let clientContactInfoId: Int?

    // Coding keys to map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case clientName = "ClientName"
        case clientID = "ClientID"
        case contactID = "ContactID"
        case divisionName = "DivisionName"
        case pendingTS = "PendingTS"
        case divisionId = "DivisionId"
        case showLogin = "ShowLogin"
        case showBreakminutes = "ShowBreakminutes"
        case name = "Name"
        case master = "Master"
        case clientContactInfoId = "ClientContactInfoId"
    }
}

extension DivisionList {
    static var mock: DivisionList {
        DivisionList(
            clientName: "Mock Client",
            clientID: 123,
            contactID: 456,
            divisionName: "Mock Division",
            pendingTS: 0,
            divisionId: 789,
            showLogin: 1,
            showBreakminutes: 1,
            name: "Mock Name",
            master: 0,
            clientContactInfoId: 111
        )
    }
}

