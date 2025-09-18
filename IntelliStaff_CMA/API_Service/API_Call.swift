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

enum AuthType {
    case bearer
    case basic
    case none
}

struct APIService {
    static func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        urlParams: [String: Any]? = nil,
        parameters: [String: Any]? = nil,
        body: Data? = nil,
        token: String? = nil,
        headers: [String: Any]? = nil,
        authType: AuthType = .bearer,
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
        if body != nil{
            request.httpBody = body
        }
        if let parameters = parameters, method != .get {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw NetworkError.encodingFailed
            }
        }
        
        var finalHeaders = headers ?? [:]
        
        switch authType {
        case .bearer:
            let accessToken = token ?? APIConstants.accessToken
            if !accessToken.isEmpty {
                finalHeaders["Authorization"] = "Bearer \(accessToken)"
//                print("the access token is \(accessToken)")
            }

        case .basic:
            if let basicToken = token, !basicToken.isEmpty {
                finalHeaders["Authorization"] = "Basic \(basicToken)"
//                print("the basic token is \(basicToken)")
            }

        case .none:
            break
        }
        
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


import Foundation

final class APIHandler {
    static let shared = APIHandler()
    private init() {}

    // Generic request method
    func request<T: Decodable>(
        url: URL?,
        method: String = "GET",
        body: Data? = nil,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        
        // Check URL
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = headers
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
        
        // Call API
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Validate response
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // Decode response
            return try decodeResponse(T.self, from: data)
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternet
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw error
            }
        }
        
        
        catch {
            throw error
        }
    }
    
    // MARK: - JSON Decoder with detailed error logs
    private func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            let message: String
            switch error {
            case .keyNotFound(let key, let context):
                message = "Missing key '\(key.stringValue)' at path: \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .typeMismatch(let type, let context):
                message = "Type mismatch for \(type) at path: \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .valueNotFound(let type, let context):
                message = "Value not found for \(type) at path: \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .dataCorrupted(let context):
                message = "Data corrupted: \(context.debugDescription)"
            @unknown default:
                message = "Unknown decoding error"
            }
            // Throw a custom error including the message, or propagate as needed
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: message
                )
            )
        } catch {
            // For non-DecodingErrors, we can simply propagate or wrap them
            throw error
        }
    }

}
