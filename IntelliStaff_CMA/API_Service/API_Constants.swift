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
    
}
