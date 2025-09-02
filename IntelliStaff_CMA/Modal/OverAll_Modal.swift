//
//  OverAll_Modal.swift
//  IntelliStaff_CMA
//
//  Created by ios on 02/09/25.
//
import Foundation
import SwiftUI

struct ECheckInAllResponse: Codable, Identifiable {
    let candID: Int
     let candidateName: String?
     let orderID: Int
     let weekEnd, billDate, startTime, endTime: String
     let checkIn, checkOut: String
     let txnType: Int
     let routeName: String
     let totalHours, roundedTotalHours: Double
     let breakMinutes: Int
     let recCode: String
     var payforBreak: Bool
     let position: String
     let isAdminUser, status, id, reasonID: Int
     let reasonForTimeChange, additionalComments: JSONNull?
     var isSubmitted: Int
     let otherReason, positionLabelColor: String
     let reportTo: JSONNull?
     let rating: Int
     let ratingComments: String

     enum CodingKeys: String, CodingKey {
         case candID = "CandId"
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
         case roundedTotalHours = "RoundedTotalHours"
         case breakMinutes = "BreakMinutes"
         case recCode = "RecCode"
         case payforBreak = "PayforBreak"
         case position = "Position"
         case isAdminUser = "ISAdminUser"
         case status = "Status"
         case id = "Id"
         case reasonID = "ReasonId"
         case reasonForTimeChange = "ReasonForTimeChange"
         case additionalComments = "AdditionalComments"
         case isSubmitted = "IsSubmitted"
         case otherReason = "OtherReason"
         case positionLabelColor = "PositionLabelColor"
         case reportTo = "ReportTo"
         case rating = "Rating"
         case ratingComments = "RatingComments"
     }
 }

 typealias ECheckInAllResponseObj = [ECheckInAllResponse]

 // MARK: - Encode/decode helpers

 class JSONNull: Codable, Hashable {

     public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
             return true
     }

     public var hashValue: Int {
             return 0
     }

     public init() {}

     public required init(from decoder: Decoder) throws {
             let container = try decoder.singleValueContainer()
             if !container.decodeNil() {
                     throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
             }
     }

     public func encode(to encoder: Encoder) throws {
             var container = encoder.singleValueContainer()
             try container.encodeNil()
     }
 }


struct RatingResponse: Codable {
    let message: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case message
        case statusCode = "StatusCode"
    }
}

// MARK: - Data Models
struct AttendanceItem {
    let id: Int
    let name: String
    let position: String
    let positionLabelColor: String?
    let startTime: String
    let endTime: String
    let checkIn: String
    let checkOut: String
    let breakMinutes: String
    let reasonId: String
    let reason: String?
    let status: String
    let txnType: String
    let isAdminUser: String
    let isIrregular: String
    let reasonIndex: String
    let isSubmitted: String
    let rating: String
    let totalHours: String?
}

struct AllItem: Codable {
    var name: String
    var position: String
    var startTime: String
    var endTime: String
    var orderId: Int
    var weekEnd: String
    var isAdminUser: Int
    var checkOut: String
    var billDate: String
    var payforBreak: Bool
    var recCode: String
    var candId: Int
    var checkIn: String
    var breakMinutes: Int
    var itemId: Int
    var status: Int
    var txnType: Int
    var isSubmitted: Int
    var reasonId: Int
    var rating: Int
    var ratingComments: String
    var positionLabelColor: String
    var otherReason: String
    var totalHours: String
    var reason: String
    var isIrregular: String
    
    var totalHoursInt: Int {
        Int(totalHours) ?? 0
    }
    
    var isRegularHours: Bool {
        totalHoursInt >= 330 && totalHoursInt <= 810
    }
    
    var statusColor: Color {
        if status == 0 && txnType == 0 {
            return Color.orange.opacity(0.3)
        } else if status == 0 && txnType == 3 {
            return Color.orange.opacity(0.5)
        } else if status == 1 {
            return Color.green.opacity(0.3)
        } else if status == 2 {
            return Color.red.opacity(0.3)
        }
        return Color.clear
    }
    
    var cellInfoColor: Color {
        isSubmitted == 1 ? Color.green : Color.yellow
    }
}


struct ReasonResponse: Codable {
    let message: String
    let statusCode, retry, sleep: Int

    enum CodingKeys: String, CodingKey {
        case message
        case statusCode = "StatusCode"
        case retry = "Retry"
        case sleep = "Sleep"
    }
}

struct ECheckInRecord: Identifiable, Codable, Equatable {
    let id: Int
    var candId: Int
    var candidateName: String
    var orderId: Int
    var weekEnd: String
    var billDate: String
    var startTime: String
    var endTime: String
    var checkIn: String
    var checkOut: String
    var txnType: Int
    var routeName: String
    var totalHours: Double
    var roundedTotalHours: Double
    var breakMinutes: Int
    var recCode: String
    var payforBreak: Bool
    var position: String
    var isAdminUser: Int
    var status: Int
    var reasonId: Int
    var reasonForTimeChange: String?
    var additionalComments: String?
    var isSubmitted: Int
    var otherReason: String
    var positionLabelColor: String
    var reportTo: String?
    var rating: Double
    var ratingComments: String
}
