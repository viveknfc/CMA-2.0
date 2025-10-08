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
    let isPasswordChange: Bool?
    let expiresIn: Int?
    let refreshToken: String?
    let accessToken: String
    let requestingPartyToken: String?
    let message: String?
    let username: String?
}

//struct LoginResponse: Decodable, Hashable {
//    let isPasswordChange: Bool
//    let expiresIn: Int
//    let refreshToken: String
//    let accessToken: String
//    let requestingPartyToken: String
//    let message: String
//    let username: String
//}

struct SendOTPResponse: Decodable{
    let code, message, ttl: String
}

struct UpdatePasswordResponse: Codable {
    var message: String?
}

struct AssignmentResponse: Decodable {
    let totalRows: Int
    let candateAssignmentsDetailsList: [CandidateAssignmentDashboard]

    enum CodingKeys: String, CodingKey {
        case totalRows = "TotalRows"
        case candateAssignmentsDetailsList = "CandateAssignmentsDetailsList"
    }
}

struct CandidateAssignmentDashboard: Decodable {
    let orderID: Int
    let clientId: String?
    let startDate: String
    let endDate: String
    let position: String
    let poNumber: String
    let cancelled: String?
    let companyName: String
    let minpay: Double
    let minbill: Double
    let shifts: Int
    let status: String
    let orderWeekdayDetails: String?

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderID"
        case clientId = "ClientId"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case position = "Position"
        case poNumber = "PoNumber"
        case cancelled = "Cancelled"
        case companyName = "CompanyName"
        case minpay = "Minpay"
        case minbill = "Minbill"
        case shifts = "Shifts"
        case status = "Status"
        case orderWeekdayDetails = "OrderWeekdayDetails"
    }
}
