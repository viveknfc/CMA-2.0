//
//  API_Constants.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 16/07/25.
//

enum APIConstants {
    
    static var DevelopmentURL = "https://tempositionsdev.com/"
    static var ProducitonURL = "https://apps.tempositions.com/"
    static let baseURL = DevelopmentURL
    
    static var accessToken = ""
    
    static let ServiceAuthAPI = "auth/api/User/ServiceAuth"
    static var LoginAPI = "auth/api/User/token"
    
    static var DivisionList = "lookupapi/GetCWAClientLogin"
    
    static var CMADashboardDetails = "clientsapi/GetCwaMenuInformation"
    static var CandidateDetailsAPI = "candidateapi/api/Candidate/CandidateDetails"
    
}
