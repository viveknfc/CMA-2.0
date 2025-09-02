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


    
    //MARK: - Overall UI
    static func overallUICalling(params: [String: Any]) async throws -> ([ECheckInAllResponse], String?) {
        print("Calling E-Check In API with params: \(params)")
        
        // Build query string from params
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.testURL)\(APIConstants.EAllData)?\(queryString)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        let data: Data = try await APIService.request(
            url: url.absoluteString,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Basic \(token)"]
        )
        
        // Try decode normal data
        if let result = try? JSONDecoder().decode([ECheckInAllResponse].self, from: data), !result.isEmpty {
            return (result, nil)
        }
        
        
        // Try decode no-data response
        if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
           let first = noData.first {
            return ([], first.message)
        }
        
        throw NetworkError.decodingFailed
    }
    
    
    //MARK: - FeedBack UI
    static func submitRatingCalling(params: [String: Any]) async throws -> ([RatingResponse], String?) {
        print("Calling E-Check In API with params: \(params)")
        
        // Build query string from params
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.testURL)\(APIConstants.Rating)?\(queryString)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        let data: Data = try await APIService.request(
            url: url.absoluteString,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Basic \(token)"]
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
    
    //MARK: - Delete UI
    static func deleteCalling(params: [String: Any]) async throws -> ([RatingResponse], String?) {
        print("Calling E-Check In API with params: \(params)")
        
        // Build query string from params
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.testURL)\(APIConstants.EDelete)?\(queryString)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        let data: Data = try await APIService.request(
            url: url.absoluteString,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Basic \(token)"]
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
        
        let url = APIConstants.testURL + APIConstants.ESaveReason
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        
        
        let data: Data = try await APIService.request(
            url: url,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Basic \(token)"]
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
    ) async throws -> ([RatingResponse], String?) {
        print("Calling E-Check In API with params: \(params)")
        
        let queryString = params
            .flatMap { dict in
                dict.map { "\($0.key)=\($0.value)" }
            }
            .joined(separator: "&")

        // Prepare URL
        let urlString = "\(APIConstants.testURL)\(APIConstants.ESubmitAll)?\(queryString)"
        var jsonString = String()
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            jsonString = String(data: jsonData, encoding: .utf8) ?? ""
                print(jsonString)
                // 👉 Use this jsonString in your API call
            
        } catch {
            print("Error converting to JSON: \(error)")
        }
        
        let termData = jsonString.data(using: .utf8)
        
        print(termData)

        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.addValue("Basic ddhaiti24@yahoo.com:iFs0pWWk9QfEA6YZhVSKZ4yTVzP3O3dz", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = termData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            
        }
            let (data, response) = try await URLSession.shared.data(for: request)
                
                print(String(data: data, encoding: .utf8)!)
                
                // Try to decode as RatingResponse array first
                if let result = try? JSONDecoder().decode([RatingResponse].self, from: data),
                   !result.isEmpty {
                    return (result, nil)
                }
                
                // Try to decode as NoDataResponse array
                if let noData = try? JSONDecoder().decode([NoDataResponse].self, from: data),
                   let first = noData.first {
                    return ([], first.message)
                }
                // If neither decode succeeds, throw an error
                throw NetworkError.decodingFailed
        
       // task.resume()
       // throw NetworkError.decodingFailed
    }


    static func saveCalling(params: [String: Any]) async throws -> ([RatingResponse], String?) {
        print("Calling E-Check In API with params: \(params)")
        
        // Build query string from params
        let queryString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        
        let urlString = "\(APIConstants.testURL)\(APIConstants.EAllSave)?\(queryString)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let token = "pkadrikar@tempositions.com:VUAvrDfCjhTn+gkeRo4o/MTbN9eVibBHDWRFUDjEJL4="
        
        let data: Data = try await APIService.request(
            url: url.absoluteString,
            method: .post,
            parameters: params,
            headers: ["Authorization": "Basic \(token)"]
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

}




class ECheckInService{
    static func submitAllDetails(params: [[String: Any]]) async throws -> Data {
        let queryString = params
            .flatMap { dict in
                dict.map { "\($0.key)=\($0.value)" }
            }
            .joined(separator: "&")

        // Prepare URL
        let urlString = "\(APIConstants.testURL)\(APIConstants.ESubmitAll)?\(queryString)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // Serialize params to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        
        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Basic ddhaiti24@yahoo.com:iFs0pWWk9QfEA6YZhVSKZ4yTVzP3O3dz", forHTTPHeaderField: "Authorization")
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
