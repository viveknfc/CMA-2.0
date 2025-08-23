//
//  API_Function.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 16/07/25.
//

import SwiftUI

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
    
    //MARK: - E-Check In API
    
    static func eCheckInAPICalling(params: [String: Any]) async throws -> ([ECheckinModal_Nw], String?) {
        print("Calling E-Check In API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.ECheckInAPI
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        // Ask APIService to just give us Data (raw response)
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            urlParams: params,
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode([ECheckinModal_Nw].self, from: data), !result.isEmpty {
            return (result, nil)
        }
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return ([], first.message)
        }
        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - E-checkin Submit API
    
    static func eCheckInSubmitAPICalling(params: [String: Any]) async throws -> [SubmitAPIResponse] {
//        print("Calling CheckIn Submit API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.ECheckInSubmit
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        return try JSONDecoder().decode([SubmitAPIResponse].self, from: data)
    }
    
    //MARK: - E-Check Out API
    
    static func eCheckOutAPICalling(params: [String: Any]) async throws -> ([ECheckinModal_Nw], String?) {
        print("Calling E-Check In API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.ECheckOutAPI
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        // Ask APIService to just give us Data (raw response)
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            urlParams: params,
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode([ECheckinModal_Nw].self, from: data), !result.isEmpty {
            return (result, nil)
        }
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return ([], first.message)
        }
        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - E-checkOut Submit API
    
    static func eCheckOutSubmitAPICalling(params: [String: Any]) async throws -> [SubmitAPIResponse] {
//        print("Calling CheckOut Submit API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.ECheckOutSubmit
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        return try JSONDecoder().decode([SubmitAPIResponse].self, from: data)
    }
    
    //MARK: - Break Min API
    
    static func breakMinAPICalling(params: [String: Any]) async throws -> ([ECheckinModal_Nw], String?) {
        print("Calling E-Check In API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.BreakMinDetails
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        // Ask APIService to just give us Data (raw response)
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            urlParams: params,
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode([ECheckinModal_Nw].self, from: data), !result.isEmpty {
            return (result, nil)
        }
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return ([], first.message)
        }
        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - Save Break Min Submit API
    
    static func saveBreakMinAPICalling(params: [String: Any]) async throws -> [SubmitAPIResponse] {
//        print("Calling Break Min Submit API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.saveBreakMin
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        return try JSONDecoder().decode([SubmitAPIResponse].self, from: data)
    }


    
}
