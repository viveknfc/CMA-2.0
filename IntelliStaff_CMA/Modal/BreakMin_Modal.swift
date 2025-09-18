//
//  BreakMin_Modal.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 17/08/25.
//
import Foundation

struct Break_Min_Modal: Codable, Identifiable {
    var id = UUID()
    var name: String
    var position: String
    var scheduledTime: Date
    var startTime: Date
    var endTime: Date
    
    var duration: Int {
        let interval = endTime.timeIntervalSince(startTime)
        return max(Int(interval / 60), 0) // avoid negative values
    }
}


struct Break_Min_Response:Codable{
    let candidateID: Int
    let candidateName: String
    let orderID: Int
    let weekEnd, billDate, startTime, endTime: String
    let checkIn, checkOut: String
    let txnType: Int
    let routeName: String
    let totalHours, breakMinutes: Int
    let timeOut, timeIn, position: String
    let isAdminUser: Int
    let positionLabelColor, recCode: String
    
    enum CodingKeys: String, CodingKey {
        case candidateID = "CandidateId"
        case candidateName = "CandidateName"
        case orderID = "OrderId"
        case weekEnd = "WeekEnd"
        case billDate = "BillDate"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case checkIn = "CheckIn"
        case checkOut = "CheckOut"
        case txnType = "TxnType"
        case routeName = "RouteName"
        case totalHours = "TotalHours"
        case breakMinutes = "BreakMinutes"
        case timeOut = "TimeOut"
        case timeIn = "TimeIn"
        case position = "Position"
        case isAdminUser = "ISAdminUser"
        case positionLabelColor = "PositionLabelColor"
        case recCode = "RecCode"
    }
}
