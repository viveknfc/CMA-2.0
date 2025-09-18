//
//  E-Checkin_Modal.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import Foundation

struct CheckInRequest: Codable {
    let candId: Int
    let orderId: Int
    let type: Int
    let weekEnd: String
    let clientId: Int
    let timeOut: String
    let totlaHours: Int
    let recCode: String
    let payForBreak: Int
    let latitude: String
    let endTime: String
    let breakMinutes: Int
    let address: String
    let checkIn: String
    let retry: Int
    let contactId: Int
    let longitude: String
    let billDate: String
    let startTime: String
    let ipAddress: String?
    let checkOut: String
    let routeName: String
    let timeIn: String
    let id: Int
    let ReasonId: Int?
    let OtherReason:String?
   
    
    enum CodingKeys: String, CodingKey {
        case orderId = "OrderId"
        case candId = "CandidateId"
        case type = "Type"
        case weekEnd = "WeekEnd"
        case clientId = "ClientId"
        case timeOut = "TimeOut"
        case totlaHours = "TotlaHours"
        case recCode = "RecCode"
        case payForBreak = "PayforBreak"
        case latitude = "Latitude"
        case endTime = "EndTime"
        case breakMinutes = "BreakMinutes"
        case address = "Address"
        case checkIn = "CheckIn"
        case retry = "Retry"
        case contactId = "ContactId"
        case longitude = "Longitude"
        case billDate = "BillDate"
        case startTime = "StartTime"
        case ipAddress = "IPAddress"
        case checkOut = "CheckOut"
        case routeName = "RouteName"
        case timeIn = "TimeIn"
        case id = "Id"
        case ReasonId = "ReasonId"
        case OtherReason = "OtherReason"
    }
}


struct ECheckinModal_Nw: Identifiable, Codable {
    let id = UUID()
    let orderId: Int
    let checkIn: String?
    let positionLabelColor: String?
    let position: String
    let weekEnd: String
    let endTime: String
    let candId: Int
    let startTime: String
    let isAdminUser: Int
    let reportTo: String?
    let payForBreak: Bool?
    let recCode: String
    let candidateName: String
    let checkOut: String?
    let billDate: String
    
    var scheduleTime: String {
        let startFormatted = Date_Time_Formatter.extractTimeIn12HourFormat(from: startTime) ?? ""
        let endFormatted   = Date_Time_Formatter.extractTimeIn12HourFormat(from: endTime) ?? ""
        return "\(startFormatted) - \(endFormatted)"
    }
    
    var startDate: Date? {
        Date_Time_Formatter.apiTimeToDate(from: startTime)
    }
    var endDate: Date? {
        Date_Time_Formatter.apiTimeToDate(from: endTime)
    }
    
    let breakMinutes: Int?
    let timeIn: String?
    let timeOut: String?

    enum CodingKeys: String, CodingKey {
        case orderId = "OrderId"
        case checkIn = "CheckIn"
        case positionLabelColor = "PositionLabelColor"
        case position = "Position"
        case weekEnd = "WeekEnd"
        case endTime = "EndTime"
        case candId = "CandidateId"
        case startTime = "StartTime"
        case isAdminUser = "ISAdminUser"
        case reportTo = "ReportTo"
        case payForBreak = "PayforBreak"
        case recCode = "RecCode"
        case candidateName = "CandidateName"
        case checkOut = "CheckOut"
        case billDate = "BillDate"
        case breakMinutes = "BreakMinutes"
        case timeIn = "TimeIn"
        case timeOut = "TimeOut"

    }
}

struct SubmitAPIResponse: Codable {
    let message: String
    let statusCode: Int
    let retry: Int
    let sleep: Int

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case statusCode = "StatusCode"
        case retry = "Retry"
        case sleep = "Sleep"
    }
}

