//
//  Untitled.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingFailed
    case encodingFailed
    case timeout
    case serverError(statusCode: Int)
    case noInternet
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "No data received from server."
        case .decodingFailed:
            return "Failed to decode the response."
        case .encodingFailed:
            return "Failed to encode the Params."
        case .timeout:
            return "The request timed out."
        case .serverError(let code):
            return "Server returned error code \(code)."
        case .noInternet:
            return "No internet connection."
        }
    }

}

enum ErrorDisplayMode {
    case toast
    case alert
}

extension NetworkError {
    var displayMode: ErrorDisplayMode {
        switch self {
        case .noInternet, .timeout:
            return .toast
        case .invalidURL, .encodingFailed, .decodingFailed, .serverError:
            return .alert
        case .noData:
            return .toast
        }
    }
}


