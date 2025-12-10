//
//  SimpleAPI.swift
//  NetworkingLayer
//

import Foundation

public struct SimpleAPI {
    
    /// Simple API caller:
    /// Pass URL, method, headers, body → get raw Data or APIError.
    
    public static func call(
        url: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        body: [String: Any]? = nil,
        completion: @escaping (Result<Data, APIError>) -> Void
    ) {
        guard let finalURL = URL(string: url) else {
            completion(.failure(.network("Invalid URL")))
            return
        }
        
        // Convert dictionary body to JSON
        var httpBody: Data? = nil
        if let body = body {
            httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        // Call APIService
        APIService.shared.request(
            url: finalURL,
            method: method,
            headers: headers,
            body: httpBody,
            requestInterceptors: [],
            responseInterceptors: [],
            completion: completion
        )
    }
}
