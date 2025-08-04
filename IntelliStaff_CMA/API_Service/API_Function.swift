//
//  API_Function.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 16/07/25.
//

struct APIFunction {
    
    //MARK: - serviceAuthAPICalling
    
    static func serviceAuthAPICalling() async throws -> TokenResponse {
        let params:[String:String] = ["userData": "N6aM+1OPod0PNWGFb4Xg68jVcwJpeWWzXxtiGXG8VH3VEAZZt7D9VMPnkhHQwxrBn9OI8l5GM73kFTQ4BVJudOoGc1j0dIoFzeY090lHVlRHJIaRCrz/PjuE+MxJrhhs0CayK5EcFVPrOBEsZ6Z4z/PCw/XQZwaESi/YKG+axiCtDAeUOkkArclXAQY+rwPU6Vbg2g3EAKHDb9VK7eCUM80+PFi7QyQi/4vlDaVOnTq6oqgN3VQ3kdcqI4emOySvxGWMiUcWQfONRfU4ImyDbIy98UCNwwoHwKNZnAI/2cDyuEtbA5YtMnq/leaj5L0ZYkzlB3phSaUB93rZorXSaI15KK1aAbgkaVtc+bMFDm/1Wn2sZKySS97KD1CazY9q0PLG5hCA9J2bYYIdzDgGzA=="]
        let url = APIConstants.baseURL + APIConstants.ServiceAuthAPI
        return try await APIService.request(url: url, method: .post, parameters: params)
    }
    
    //MARK: - Login API
    
    static func loginAPICalling(params: [String: Any]) async throws -> LoginResponse {
        let url = APIConstants.baseURL + APIConstants.LoginAPI
        return try await APIService.request(url: url, method: .post, parameters: params)
    }
    
    //MARK: - Division List API
    
    static func divisionListAPICalling(params: [String: Any]) async throws -> [DivisionList] {
        print("Calling division List API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.DivisionList
        return try await APIService.request(url: url, urlParams: params)
    }
    
    //MARK: - Dashboard API
    
    static func dashboardAPICalling(params: [String: Any]) async throws -> [MenuItem] {
        print("Calling dashboard API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.CMADashboardDetails
        return try await APIService.request(url: url, urlParams: params)
    }
    
    //MARK: - Candidate Id API
    
    static func candidateIdAPICalling(params: [String: Any]) async throws -> CandidateIdModel {
        print("Calling candidate ID API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.CandidateDetailsAPI
        return try await APIService.request(url: url, urlParams: params)
    }
    
}
