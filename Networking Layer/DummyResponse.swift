//
//  DummyResponse.swift
//  Networking Layer
//
//  Created by Noman Belim on 04/12/25.
//

import Foundation

struct DummyResponse {
    static let products = """
    [
        { "id": 1, "title": "Noman’s First Product" },
        { "id": 2, "title": "Belim Moisturizer" },
        { "id": 3, "title": "SkinCare Lotion" }
    ]
    """.data(using: .utf8)!
}

// MARK: - Useful for debugging.
struct Logger {
    static func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}

// MARK: - Readable error messages.

enum APIError: Error {
    case network(String)       // Underlying URLSession / connectivity issues
    case invalidResponse       // Response is not HTTP or missing
    case server(String)        // Non‑2xx status code
    case decoding(String)      // JSON decoding failed
    case unknown               // Fallback for unexpected issues
}

// MARK: - All API URLs placed here.

enum APIEndpoint {
    case products
 var url: URL {
    switch self {
    case .products:
        return URL(string: "https://this-domain-does-not-exist-12345.com")!
    }
}
}

