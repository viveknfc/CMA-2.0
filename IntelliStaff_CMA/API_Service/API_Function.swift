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
        print(url)
        return try await APIService.request(url: url, method: .post, parameters: params)
    }
    
    //MARK: - Login API
    
    static func loginAPICalling(params: [String: Any]) async throws -> LoginResponse {
        let url = APIConstants.baseLoginURL + APIConstants.LoginAPI
        return try await APIService.request(url: url, method: .post, parameters: params)
    }
    
    
    //MARK: - SendOTP API
    
    static func sendOTPAPICalling(params: [String: Any]) async throws -> SendOTPResponse {
        let url = APIConstants.baseLoginURL + APIConstants.sendOTP
        print("url: \(url)")
        print("Calling otp List API with params: \(params)")
        return try await APIService.request(url: url, method: .post, parameters: params)
    }
    
    //MARK: - UpdatePassword API
    
    static func updatePasswordAPICalling(params: [String: Any]) async throws -> UpdatePasswordResponse {
        let url = APIConstants.baseLoginURL + APIConstants.updatePassowrd
        return try await APIService.request(url: url, method: .post, parameters: params)
    }
    
    //MARK: - Division List API
    
    static func divisionListAPICalling(params: [String: Any]) async throws -> [DivisionList] {
        print("Calling division List API with params: \(params)")
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let url = "\(APIConstants.baseURL)\(APIConstants.DivisionList)?\(queryString)"
     
        print(url)
        return try await APIService.request(url: url, urlParams: params, token: APIConstants.accessToken)
    }
    
    //MARK: - Dashboard API
    
    static func dashboardAPICalling(params: [String: Any]) async throws -> [MenuItem] {
        print("Calling dashboard API with params: \(params)")
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        print(queryString)
        let urlString = "\(APIConstants.baseURL)\(APIConstants.CMADashboardDetails)?\(queryString)"
        print(urlString)
        return try await APIService.request(url: urlString, urlParams: params)
    }
    
    //MARK: - Candidate Id API
    
    static func candidateIdAPICalling(params: [String: Any]) async throws -> CandidateIdModel {
        print("Calling candidate ID API with params: \(params)")
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.baseURL)\(APIConstants.CandidateDetailsAPI)?\(queryString)"
        print(urlString)
        return try await APIService.request(url: urlString, urlParams: params, headers: ["Authorization": "Bearer \(APIConstants.accessToken)"])
    }
    
    //MARK: - Demographic Details API
    
    static func demographicAPICalling(params: [String: Any]) async throws -> CandidateInfo {
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.baseURL)\(APIConstants.demoGraphicDetailsAPI)?\(queryString)"
        print(urlString)
        return try await APIService.request(url: urlString, urlParams: params, headers: ["Authorization": "Bearer \(APIConstants.accessToken)"])
    }
    
    //MARK: - E-Check In API
    
    static func eCheckInAPICalling(params: [String: Any]) async throws -> ([ECheckinModal_Nw], String?) {
        print("Calling E-Check In API with params: \(params)")
        var components = URLComponents(string: "\(APIConstants.baseURL)\(APIConstants.ECheckInAPI)")
        components?.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        guard let urlString = components?.url?.absoluteString else {
            throw NetworkError.invalidURL
        }
        
        let data: Data = try await APIService.request(
            url: urlString,
            method: .get,
            urlParams: params,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
      
        if let result = try? JSONDecoder().decode([ECheckinModal_Nw].self, from: data) {
                if !result.isEmpty {
                    return (result, nil)
                } else {
                    // API returned []
                    return ([], "No records found")
                }
            }
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataCheckInResponse].self, from: data),
           let first = noData.first {
            return ([], first.statusMessage)
        }
        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - E-checkin Submit API
    
    static func eCheckInSubmitAPICalling(params: [String: Any]) async throws -> SubmitAPIResponse {
//        print("Calling CheckIn Submit API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.ECheckInSubmit
        
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            body: jsonData,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )

        return try JSONDecoder().decode(SubmitAPIResponse.self, from: data)
    }
    
    //MARK: - E-Check Out API
    
    static func eCheckOutAPICalling(params: [String: Any]) async throws -> ([ECheckinModal_Nw], String?) {
        print("Calling E-Check In API with params: \(params)")
        // Build URL components
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.baseURL)\(APIConstants.ECheckOutAPI)?\(queryString)"

        // Ask APIService to just give us Data (raw response)
        let data: Data = try await APIService.request(
            url: urlString, // 👈 keep it as URL, not String
            method: .get,
            urlParams: params, // no need to pass again
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode([ECheckinModal_Nw].self, from: data) {
                if !result.isEmpty {
                    return (result, nil)
                } else {
                    // API returned []
                    return ([], "No records found")
                }
            }
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataCheckInResponse].self, from: data),
           let first = noData.first {
            return ([], first.statusMessage)
        }
        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - E-checkOut Submit API
    
    static func eCheckOutSubmitAPICalling(params: [String: Any]) async throws -> SubmitAPIResponse {
//        print("Calling CheckOut Submit API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.ECheckOutSubmit
        
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            body: jsonData,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
        
        return try JSONDecoder().decode(SubmitAPIResponse.self, from: data)
    }
    
    //MARK: - Break Min API
    
    static func breakMinAPICalling(params: [String: Any]) async throws -> ([ECheckinModal_Nw], String?) {
        print("Calling E-Check In API with params: \(params)")
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.baseURL)\(APIConstants.BreakMinDetails)?\(queryString)"
        // Ask APIService to just give us Data (raw response)
        let data: Data = try await APIService.request(
            url: urlString,
            method: .get,
            urlParams: params,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
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
        print("\(NetworkError.decodingFailed.failureReason ?? "")")
        throw NetworkError.decodingFailed
    }
    
    //MARK: - Save Break Min Submit API
    
    static func saveBreakMinAPICalling(params: [String: Any]) async throws -> [SubmitAPIResponse] {
//        print("Calling Break Min Submit API with params: \(params)")
        let url = APIConstants.baseURL + APIConstants.saveBreakMin
        
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            body: jsonData,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
       // throw NetworkError.decodingFailed
       return try JSONDecoder().decode([SubmitAPIResponse].self, from: data)
    }


    
    //MARK: - Overall UI
    static func overallUICalling(params: [String: Any]) async throws -> ([ECheckInAllResponse], String?) {
        print("Calling E-Check In API with params: \(params)")
        
        // Build query string from params
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.baseURL)\(APIConstants.EAllData)?\(queryString)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        
        let data: Data = try await APIService.request(
            url: url.absoluteString,
            method: .get,
            parameters: params,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
        // Try decode normal data
        if let result = try? JSONDecoder().decode([ECheckInAllResponse].self, from: data) {
                if !result.isEmpty {
                    return (result, nil)
                } else {
                    // API returned []
                    return ([], "No records found")
                }
            }
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataAllDetail].self, from: data),
           let first = noData.first {
            return ([], first.statusMessage)
        }
        
        throw NetworkError.decodingFailed
    }
    
    
    //MARK: - FeedBack UI
    static func submitRatingCalling(params: [String: Any]) async throws -> (RatingResponse, String?) {
        print("Calling E-Check In API with params: \(params)")
        let urlString = APIConstants.baseURL + APIConstants.Rating
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        let data: Data = try await APIService.request(
            url: url.absoluteString,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode(RatingResponse.self, from: data), !result.message.isEmpty {
            return (result, nil)
        }
//        
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return (try RatingResponse(from: self as! Decoder), first.message) // assuming RatingResponse has a default init
        }
        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - Delete UI
    static func deleteCalling(params: [String: Any]) async throws -> ([RatingResponse], String?) {
        print("Calling E-Check In API with params: \(params)")
        
        let urlString = APIConstants.baseURL + APIConstants.EDelete
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
       // let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        let data: Data = try await APIService.request(
            url: url.absoluteString,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode([RatingResponse].self, from: data), !result.isEmpty {
            return (result, nil)
        }
        
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return ([], first.message)
        }
        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - reason Api Calling
    static func reasonAPICalling(params: [String: Any]) async throws -> ([ReasonResponse], String?) {
        print("Calling candidate ID API with params: \(params)")
        
        let url = APIConstants.baseURL + APIConstants.ESaveReason
        
        
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
        if let result = try? JSONDecoder().decode([ReasonResponse].self, from: data), !result.isEmpty {
            return (result, nil)
        }
        
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return ([], first.message)
        }
        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - Overall Submit
    static func overallSubmitCalling(
        params: [[String: Any]]
    ) async throws -> (OverallSubmitResponse, String?) {
        print("Calling overall API with params: \(params)")
        
        let data: Data = try await ECheckInService.submitAllDetails(params: params)
        
        if let result = try? JSONDecoder().decode(OverallSubmitResponse.self, from: data), !result.message.isEmpty {
            return (result, nil)
        }
        
        var ratingObj:OverallSubmitResponse!
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return (ratingObj, first.message)
        }
        
        throw NetworkError.decodingFailed
        

    }


    static func saveCalling(params: [String: Any]) async throws -> (RatingResponse, String?) {
        print("Calling E-Check In API with params: \(params)")
        let urlString = APIConstants.baseURL + APIConstants.EAllSave
        let data: Data = try await APIService.request(
            url: urlString,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode(RatingResponse.self, from: data), !result.message.isEmpty {
            return (result, nil)
        }
        
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return (try RatingResponse(from: self as! Decoder), first.message) // assuming RatingResponse has a default init
        }

        
        throw NetworkError.decodingFailed
    }
    
    //MARK: - SubVendor API
    
    static func subVendorAPICalling(params: [String: Any]) async throws -> SubVendorResponse {
        print("Calling E-Check In API with params: \(params)")
        
        // Build query string from params
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.uatBaseURL)\(APIConstants.subVendor)?\(queryString)"
        print(urlString)
        print(params)
        return try await APIService.request(url: urlString, method: .get, parameters: params,headers: ["Authorization": "Bearer \(APIConstants.accessToken)"])
    }
    
    //MARK: - clients API
    
    static func clientAPICalling(params: [String: Any]) async throws -> ClientResponse {
        print("Calling E-Check In API with params: \(params)")
        
        // Build query string from params
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.uatBaseURL)\(APIConstants.clientInfo)?\(queryString)"
        print(urlString)
        print(params)
        return try await APIService.request(url: urlString, method: .get, parameters: params, headers: ["Authorization": "Bearer \(APIConstants.accessToken)"])
    }
    
    
    //MARK: - Division Theme
    static func clientThemeAPICalling(params: [String: Any]) async throws -> [GetDivisionThemeModel]{
        print("Calling E-Check In API with params: \(params)")
        
        // Build query string from params
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.uatBaseURL)\(APIConstants.GetDivisionTheme)?\(queryString)"
        print(urlString)
        return try await APIService.request(url: urlString, method: .get, parameters: params)
    }
    
    
    //MARK: - Order Tracking
    static func orderTrackingAPICalling(params: [String: Any]) async throws -> ([OrderResponse], String?) {
        let url = APIConstants.uatBaseURL + APIConstants.scheduleDetails
        print(url)
        print("Calling orders In API with params: \(params)")
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Bearer \(APIConstants.accessToken)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode([OrderResponse].self, from: data),
           !result.isEmpty {
            return (result, nil)
        }
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return ([], first.message)
        }
        
        throw NetworkError.decodingFailed
    }


}




class ECheckInService{
    static func submitAllDetails(params: [[String: Any]]) async throws -> Data {
        // Prepare URL
        let urlString = APIConstants.baseURL + APIConstants.ESubmitAll
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // Serialize params to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        
        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(APIConstants.accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Use async/await URLSession data(for:) method
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response status code
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.decodingFailed
        }
        
        return data
    }
    
    
   


}
