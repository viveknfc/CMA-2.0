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
    //UATURL
    //DevelopmentURL
    //static var testURL = "https://tempositionsdev.com/TemPositionsCMAAPIDEV/CWAAPI/"
    static var accessToken = ""
    
    static let ServiceAuthAPI = "auth/api/User/ServiceAuth"
    static var LoginAPI = "auth/api/User/token"
    
    static var DivisionList = "lookupapi/GetCWAClientLogin"
    
    static var CMADashboardDetails = "clientsapi/GetCwaMenuInformation"
    static var CandidateDetailsAPI = "Clientsapi/GetCwaClientDefaultDetails"
    static var demoGraphicDetailsAPI = "eregisterapi/api/personalInfo/demographics"
    
    static var ECheckInAPI = "clientsapi/GetCheckInDetails"
    //CWAAPI/eCheckIn/GetCheckInDetails"
    static var ECheckInSubmit = "clientsapi/CheckIn"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/CheckIn"
    //CWAAPI/eCheckIn/CheckIn"
    
    static var ECheckOutAPI = "clientsapi/GetCheckOutDetails"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/GetCheckOutDetails"
    static var ECheckOutSubmit = "clientsapi/CheckOut"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/CheckOut"
    
    static var BreakMinDetails =  "clientsapi/GetBreakMinuteDetails"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/GetBreakMinuteDetails"
    static var saveBreakMin = "clientsapi/SaveBreakMinutes"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/SaveBreakMinutes"
    static let ERegisterGetDivision = "eCheckIn/GetClientsList"
//    static let ECheckInData = "eCheckIn/GetCheckInDetails"
//    static let ECheckInButton = "eCheckIn/CheckIn"
//    static let ECheckOutData = "eCheckIn/GetCheckOutDetails"
//    static let ECheckOutButton = "eCheckIn/CheckOut"
//    static let EBreakMinData = "eCheckIn/GetBreakMinuteDetails"
//    static let EBreakMinSave = "eCheckIn/SaveBreakMinutes"
    static let EAllData =  "clientsapi/GetAllDetails"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/GetAllDetails"
    static let EAllSave = "clientsapi/SaveCheckinCheckOut"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/SaveCheckinCheckOut"
    static let ESaveReason = "clientsapi/SubmitReason"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/SubmitReason"
    static let EDelete =  "clientsapi/DeleteCheckinCheckOut"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/DeleteCheckinCheckOut"
    static let EAddTime = "eCheckIn/AddAdjustmenthours"
    static let ESubmitAll = "clientsapi/SubmitAllDetails"
    //"TemPositionsCMAAPIDEV/CWAAPI/eCheckIn/SubmitAllDetails"
    //Rating
    static let Rating = "clientsapi/SubmitRating"
    
    static let sendOTP = "auth/api/User/sendotp"
    static let updatePassowrd = "auth/api/User/updatepassword"
    
    static let subVendor = "clientsapi/GetVendorType"
    
    static let clientInfo = "clientsapi/GetCwaClientDefaultDetails"
    
}
