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
        let candidateName: String
        let orderID: Int
        let weekEnd, billDate, startTime, endTime: String
        let checkIn, checkOut: String
        let txnType: Int
        let routeName: String
        let totalHours, roundedTotalHours: Double
        let breakMinutes: Int
        let recCode: String
        let payforBreak: Bool
        let position: String
        let isAdminUser, status, id, reasonID: Int
        let reasonForTimeChange, additionalComments: String?
        let isSubmitted: Int
        let otherReason: String?
        let positionLabelColor: String
        let reportTo: String?
        let rating: Int
        let ratingComments: String?
        var canBeSelected: Bool {
            return isSubmitted == 0
        }
        enum CodingKeys: String, CodingKey {
            case candID = "CandidateId"
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
            
            
            print(container.codingPath)
        }
    }



struct RatingResponse: Codable {
    let message: String
    let statusCode:Int
        let Retry, Sleep: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case statusCode = "StatusCode"
        case Sleep = "Sleep"
        case Retry = "Retry"
    }
}


struct OverallSubmitResponse: Codable {
    let success: Bool
    let message: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case message = "Message"
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
    let statusCode:Int
    let retry, sleep: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
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


struct SubVendorResponse: Codable {
    let isSubVendor: Int

    enum CodingKeys: String, CodingKey {
        case isSubVendor = "IsSubVendor"
    }
}

struct ClientResponse: Codable {
    var name, companyName, repName, repPhone: String?
    var repEmail, title, phone, ext: String?
    var fax, addETo: String?
    let master: Int?
    let contactAddress: String?
    let fl: JSONNull?
    let city, state, codeZip: String?
    let noTsApproveConf, rosAuthorized, cwaTs, cwaInvoice: Int?
    let cwaRpt, cwaEditBilling: Int?
    let division, children: StringOrInt?
    let office: Int?
    let compName, companyAddress, companyCity, mainTelPhone: String?
    let clientRepID: Int?
    let suite: JSONNull?
    let companyState, companyCodeZip: String?
    let consolidateMaster, hideIbInvoice, eTimeClock, noIbClient: Int?
    let customType, billContactID, invFileType, invoiceType: Int?
    let doNotServ, invoiceSendType, payByCompany: Int?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case companyName = "CompanyName"
        case repName = "RepName"
        case repPhone = "RepPhone"
        case repEmail = "RepEmail"
        case title = "Title"
        case phone = "Phone"
        case ext = "Ext"
        case fax = "Fax"
        case addETo = "AddETo"
        case master = "Master"
        case contactAddress = "ContactAddress"
        case fl = "Fl"
        case city = "City"
        case state = "State"
        case codeZip = "CodeZip"
        case noTsApproveConf = "NoTsApproveConf"
        case rosAuthorized = "RosAuthorized"
        case cwaTs = "CwaTs"
        case cwaInvoice = "CwaInvoice"
        case cwaRpt = "CwaRpt"
        case cwaEditBilling = "CwaEditBilling"
        case division = "Division"
        case children = "Children"
        case office = "Office"
        case compName = "CompName"
        case companyAddress = "CompanyAddress"
        case companyCity = "CompanyCity"
        case mainTelPhone = "MainTelPhone"
        case clientRepID = "ClientRepId"
        case suite = "Suite"
        case companyState = "CompanyState"
        case companyCodeZip = "CompanyCodeZip"
        case consolidateMaster = "ConsolidateMaster"
        case hideIbInvoice = "HideIbInvoice"
        case eTimeClock = "ETimeClock"
        case noIbClient = "NoIbClient"
        case customType = "CustomType"
        case billContactID = "BillContactId"
        case invFileType = "InvFileType"
        case invoiceType = "InvoiceType"
        case doNotServ = "DoNotServ"
        case invoiceSendType = "InvoiceSendType"
        case payByCompany = "PayByCompany"
    }
}


struct GetDivisionThemeModel:Codable{
   let divisionID: Int
   let divisionName, colorCode, rgbCode, skinName: String
   let skinExtension, createdOn: String
   let isActive: Bool
   let companyURL: String
   let logoPath: String
   let apiLogoPath, apiSmallLogoPath, pdfSmallLogo, campaignLogoPath: String
   let campaignDivisionName, companyDomainURL: String
   let eProfileBannerPath, eProfileWebImages: String
   let divisionLogo, ewaBanner, cwaBanner: String?

   enum CodingKeys: String, CodingKey {
       case divisionID = "DivisionID"
       case divisionName = "DivisionName"
       case colorCode = "ColorCode"
       case rgbCode = "RGBCode"
       case skinName = "SkinName"
       case skinExtension = "SkinExtension"
       case createdOn = "CreatedOn"
       case isActive = "IsActive"
       case companyURL = "CompanyURL"
       case logoPath = "LogoPath"
       case apiLogoPath = "APILogoPath"
       case apiSmallLogoPath = "APISmallLogoPath"
       case pdfSmallLogo = "PdfSmallLogo"
       case campaignLogoPath = "CampaignLogoPath"
       case campaignDivisionName = "CampaignDivisionName"
       case companyDomainURL = "CompanyDomainURL"
       case eProfileBannerPath = "EProfileBannerPath"
       case eProfileWebImages = "EProfileWebImages"
       case divisionLogo = "DivisionLogo"
       case ewaBanner = "EWABanner"
       case cwaBanner = "CWABanner"
   }
}


// MARK: - OrderResponse
struct OrderResponse: Codable {
    let orderId: Int
    let masterId: Int?
    let masterClientName: String
    let divisionClientId: Int?
    let divisionClientName: String?
    let subDivisionClientId: Int?
    let subDivisionClientName: String?
    let shift: String?
    let orderValue: String?
    let clientId: Int?
    let orderIcon: Int?
    let vendorType: String?
    let clientName: String?
    let child: String?
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: String?
    let startDate, endDate, enteredDate: String?
    let orderStatusId: Int?
    let orderStatus: String?
    let orderType: String?
    let candidateId: Int?
    let candidateName: String?
    let divisionId: Int?
    let divisionName: String?
    let vendorId: Int?
    let vendorName: String?
    let jobTitle: String?
    let reportToLocation: String?
    let monCancel, tueCancel, wedCancel, thuCancel, friCancel, satCancel, sunCancel: String?
    let noOfTemps: Int?
    let orderValueCount: Int?
    let clientGuid: String?
    let positionProfileId: Int?
    let reportToLocationId: Int?
    let roleId: Int?
    let email: String?
    let position: String?
    let workStation: String?
    let coordinator: String?
    let weekEnding: String?
    let address: String?
    let city: String?
    let state: String?
    let codeZip: String?
    let mainTelephone: String?
    let comments: String?
    let regionName: String?
    let poDName: String?
    let poNumber: String?
    let department: String?
    let reportTo: String?
    let totalNoOfTemps: String?
    let firstName: String?
    let lastName: String?
    let cancelled: String?
}


