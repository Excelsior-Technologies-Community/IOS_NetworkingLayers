//
//  DummyResponse.swift
//  Networking Layer
//
//  Created by Noman Belim on 04/12/25.
//

import Foundation

// MARK: - Dummy data (example only, not needed by the library user)

struct DummyResponse {
    static let products = """
    [
        { "id": 1, "title": "Noman’s First Product" },
        { "id": 2, "title": "Belim Moisturizer" },
        { "id": 3, "title": "SkinCare Lotion" }
    ]
    """.data(using: .utf8)!
}

// MARK: - Useful for debugging (exposed publicly)

public struct Logger {
    public static func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}

// MARK: - Readable error messages (exposed publicly)

public enum APIError: Error {
    case network(String)       // Underlying URLSession / connectivity issues
    case invalidResponse       // Response is not HTTP or missing
    case server(String)        // Non‑2xx status code
    case decoding(String)      // JSON decoding failed
    case unknown               // Fallback for unexpected issues
}

// MARK: - All API URLs placed here (example)

enum APIEndpoint {
    case products
    
    var url: URL {
        switch self {
        case .products:
            // You can change this to any endpoint while testing.
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        }
    }
}


