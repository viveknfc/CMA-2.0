//
//  API_Call.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct EmptyResponse: Decodable {}

struct ErrorResponse: Decodable {
    let message: String
}

struct APIService {
    static func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        urlParams: [String: Any]? = nil,
        parameters: [String: Any]? = nil,
        headers: [String: Any]? = nil,
        timeout: TimeInterval = 30
    ) async throws -> T {
        
        guard var components = URLComponents(string: url) else {
            throw NetworkError.invalidURL
        }

        if let urlParams = urlParams {
            components.queryItems = urlParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout

        if let parameters = parameters, method != .get {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw NetworkError.encodingFailed
            }
        }

        var finalHeaders = headers ?? [:]
        
        if finalHeaders["Authorization"] == nil {
            if !APIConstants.accessToken.isEmpty {
//                print("🔑 Using default APIConstants.accessToken: \(APIConstants.accessToken)")
                finalHeaders["Authorization"] = "Bearer \(APIConstants.accessToken)"
            }
        } else {
            print("🔑 Using caller-provided Authorization header")
        }

        
        finalHeaders["Content-Type"] = "application/json"
        for (key, value) in finalHeaders {
            request.setValue(value as? String, forHTTPHeaderField: key)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }

            // ✅ Handle non-200 responses
            guard (200..<300).contains(httpResponse.statusCode) else {
                if !data.isEmpty,
                   let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    print("the error message is ", errorResponse.message)
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorResponse.message)
                }
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            if data.isEmpty {
                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                } else {
                    throw NetworkError.noData
                }
            }

            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
//            if let rawJSON = String(data: data, encoding: .utf8) {
//                print("🟡 Raw JSON Response: \(rawJSON)")
//            }

            do {
                if T.self == Data.self {
                    return data as! T   // 👈 allow raw Data passthrough
                }
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("❌ Decoding error: \(error)")
                throw NetworkError.decodingFailed
            }

        } catch let error as URLError {
            if error.code == .timedOut {
                throw NetworkError.timeout
            }
            throw error // other URLError
        } catch {
            throw error
        }
    }
}

