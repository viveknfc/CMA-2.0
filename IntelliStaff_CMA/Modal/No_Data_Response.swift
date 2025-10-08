//
//  No_Data_Response.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 19/08/25.
//

struct NoDataResponse: Codable {
    let message: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case statusCode = "StatusCode"
    }
}


import Foundation

// MARK: - Response Model
struct NoDataCheckInResponse: Codable {
    let candidateId: Int?
    let candidateName: String?
    let orderId: Int
    let weekEnd: String
    let billDate: String
    let startTime: String?
    let endTime: String?
    let recCode: String?
    let payForBreak: Bool
    let position: String?
    let isAdminUser: Bool?
    let positionLabelColor: String?
    let checkIn: String?
    let statusMessage: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case candidateId = "CandidateId"
        case candidateName = "CandidateName"
        case orderId = "OrderId"
        case weekEnd = "WeekEnd"
        case billDate = "BillDate"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case recCode = "RecCode"
        case payForBreak = "PayforBreak"
        case position = "Position"
        case isAdminUser = "ISAdminUser"
        case positionLabelColor = "PositionLabelColor"
        case checkIn = "CheckIn"
        case statusMessage = "StatusMessage"
        case statusCode = "StatusCode"
    }
}



// MARK: - CheckInDetail
struct NoDataAllDetail: Codable {
    let candidateId: Int?
    let candidateName: String?
    let orderId: Int?
    let weekEnd: String?
    let billDate: String?
    let startTime: String?
    let endTime: String?
    let checkIn: String?
    let checkOut: String?
    let txnType: Int
    let routeName: String?
    let totalHours: Double
    let roundedTotalHours: Double
    let breakMinutes: Int?
    let recCode: String?
    let payForBreak: Bool
    let position: String?
    let isAdminUser: Bool?
    let status: String?
    let id: Int?
    let reasonId: Int?
    let reasonForTimeChange: String?
    let additionalComments: String?
    let isSubmitted: Bool?
    let otherReason: String?
    let positionLabelColor: String?
    let reportTo: String?
    let rating: Int
    let ratingComments: String?
    let statusMessage: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case candidateId = "CandidateId"
        case candidateName = "CandidateName"
        case orderId = "OrderId"
        case weekEnd = "WeekEnd"
        case billDate = "BillDate"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case checkIn = "CheckIn"
        case checkOut = "CheckOut"
        case txnType = "TxnType"
        case routeName = "RouteName"
        case totalHours = "TotalHours"
        case roundedTotalHours = "RoundedTotalHours"
        case breakMinutes = "BreakMinutes"
        case recCode = "RecCode"
        case payForBreak = "PayforBreak"
        case position = "Position"
        case isAdminUser = "ISAdminUser"
        case status = "Status"
        case id = "Id"
        case reasonId = "ReasonId"
        case reasonForTimeChange = "ReasonForTimeChange"
        case additionalComments = "AdditionalComments"
        case isSubmitted = "IsSubmitted"
        case otherReason = "OtherReason"
        case positionLabelColor = "PositionLabelColor"
        case reportTo = "ReportTo"
        case rating = "Rating"
        case ratingComments = "RatingComments"
        case statusMessage = "StatusMessage"
        case statusCode = "StatusCode"
    }
}
