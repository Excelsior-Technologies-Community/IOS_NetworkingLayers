//
//  APIError.swift
//  NetworkingKit
//

import Foundation

/// Readable error messages used across the networking layer.
public enum APIError: Error, CustomStringConvertible {
    
    case network(String)       // URLSession or connection issue
    case invalidResponse       // Response was not a proper HTTP response
    case server(String)        // Non-2xx status code
    case decoding(String)      // JSON decoding failed
    case unknown               // Fallback
    
    public var description: String {
        switch self {
        case .network(let msg): return "Network error: \(msg)"
        case .invalidResponse:  return "Invalid server response."
        case .server(let msg):  return "Server error: \(msg)"
        case .decoding(let msg): return "Decoding failed: \(msg)"
        case .unknown:          return "Unknown error occurred."
        }
    }
}
