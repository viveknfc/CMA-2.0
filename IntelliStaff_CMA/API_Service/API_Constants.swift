//
//  API_Constants.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 16/07/25.
//

enum APIConstants {
    
    static var DevelopmentURL = "https://tempositionsdev.com/"
    static var ProducitonURL = "https://apps.tempositions.com/"
    static var UATURL = "http://172.25.16.69/intellistaffUAT/"
    static let baseURL = DevelopmentURL
    static var testURL = "https://tempositionsdev.com/TemPositionsCMAAPIDEV/CWAAPI/"
    static var accessToken = ""
    
    static let ServiceAuthAPI = "auth/api/User/ServiceAuth"
    static var LoginAPI = "auth/api/User/token"
    
    static var DivisionList = "lookupapi/GetCWAClientLogin"
    
    static var CMADashboardDetails = "clientsapi/GetCwaMenuInformation"
    static var CandidateDetailsAPI = "candidateapi/api/Candidate/CandidateDetails"
    
    static var ECheckInAPI = "TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/GetCheckInDetails"
    static var ECheckInSubmit = "TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/CheckIn"
    
    static var ECheckOutAPI = "TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/GetCheckOutDetails"
    static var ECheckOutSubmit = "TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/CheckOut"
    
    static var BreakMinDetails = "TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/GetBreakMinuteDetails"
    static var saveBreakMin = "TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/SaveBreakMinutes"
    static let ERegisterGetDivision = "eCheckIn/GetClientsList"
    static let ECheckInData = "eCheckIn/GetCheckInDetails"
    static let ECheckInButton = "eCheckIn/CheckIn"
    static let ECheckOutData = "eCheckIn/GetCheckOutDetails"
    static let ECheckOutButton = "eCheckIn/CheckOut"
    static let EBreakMinData = "eCheckIn/GetBreakMinuteDetails"
    static let EBreakMinSave = "eCheckIn/SaveBreakMinutes"
    static let EAllData = "eCheckIn/GetAllDetails"
    static let EAllSave = "eCheckIn/SaveCheckinCheckOut"
    static let ESaveReason = "eCheckIn/SubmitReason"
    static let EDelete = "eCheckIn/DeleteCheckinCheckOut"
    static let EAddTime = "eCheckIn/AddAdjustmenthours"
    static let ESubmitAll = "eCheckIn/SubmitAllDetails"
    //Rating
    static let Rating = "echeckin/SubmitRating"
    
}
