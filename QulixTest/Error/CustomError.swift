//
//  CustomError.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 27.11.21.
//

import Foundation

enum CustomError: Error {
    case apiError
    case noConnection
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedErrorDescription: String {
        switch self {
        case .apiError:
            return "Stoped"
        case .noConnection:
            return "No internet connection"
        case .invalidEndpoint:
            return "Invalid endpoint"
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "No data"
        case .serializationError:
            return "Failed to decode data"
        }
    }
}
