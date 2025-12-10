//
//  APIService.swift .swift
//  Networking Layer
//
//  Created by Noman Belim on 04/12/25.
//

import Foundation

// MARK: - HTTP Method

/// Public HTTP methods supported by the networking layer.
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

// MARK: - Interceptors

/// Allows you to modify a request before it is sent (e.g. add auth headers).
public protocol RequestInterceptor {
    func intercept(_ request: URLRequest) -> URLRequest
}

/// Allows you to observe / react to every response (e.g. global logging, token refresh).
public protocol ResponseInterceptor {
    func intercept(data: Data?, response: URLResponse?, error: Error?)
}

// MARK: - API Service (Reusable Networking Layer)

/// Reusable networking service that supports GET / POST / PUT / DELETE with
/// logging, error handling and interceptor support.
public final class APIService {
    
    /// Shared singleton instance, convenient for most apps.
    public static let shared = APIService()
    
    private let session: URLSession
    
    /// Designated initializer, public so advanced users can inject their own `URLSession`.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Low‑level, reusable request handler that supports all HTTP methods.
    ///
    /// - Parameters:
    ///   - url: Endpoint URL.
    ///   - method: HTTP method (GET/POST/PUT/DELETE).
    ///   - headers: Extra HTTP headers.
    ///   - body: Optional HTTP body.
    ///   - requestInterceptors: Interceptors run before the request is sent.
    ///   - responseInterceptors: Interceptors run after a response/error is received.
    ///   - completion: Called with `Result<Data, APIError>`.
    public func request(
        url: URL,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        body: Data? = nil,
        requestInterceptors: [RequestInterceptor] = [],
        responseInterceptors: [ResponseInterceptor] = [],
        completion: @escaping (Result<Data, APIError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Apply custom headers
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Apply request interceptors
        for interceptor in requestInterceptors {
            request = interceptor.intercept(request)
        }
        
        // Logging
        Logger.log("🌐 \(method.rawValue): \(url.absoluteString)")
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            Logger.log("📤 Body: \(bodyString)")
        }
        
        session.dataTask(with: request) { data, response, error in
            
            // Run response interceptors
            responseInterceptors.forEach { interceptor in
                interceptor.intercept(data: data, response: response, error: error)
            }
            
            if let error = error {
                Logger.log("❌ Network error: \(error.localizedDescription)")
                return completion(.failure(.network(error.localizedDescription)))
            }
            
            guard let http = response as? HTTPURLResponse else {
                Logger.log("❌ Invalid response object")
                return completion(.failure(.invalidResponse))
            }
            
            Logger.log("📥 Status Code: \(http.statusCode)")
            
            guard (200...299).contains(http.statusCode) else {
                return completion(.failure(.server("Status Code: \(http.statusCode)")))
            }
            
            completion(.success(data ?? Data()))
            
        }.resume()
    }
    
    // MARK: - Convenience helpers for common HTTP verbs
    
    /// Convenience GET wrapper around `request(...)`.
    public func get(
        url: URL,
        headers: [String: String] = [:],
        requestInterceptors: [RequestInterceptor] = [],
        responseInterceptors: [ResponseInterceptor] = [],
        completion: @escaping (Result<Data, APIError>) -> Void
    ) {
        request(
            url: url,
            method: .get,
            headers: headers,
            body: nil,
            requestInterceptors: requestInterceptors,
            responseInterceptors: responseInterceptors,
            completion: completion
        )
    }
    
    /// Convenience POST wrapper around `request(...)`.
    public func post(
        url: URL,
        headers: [String: String] = [:],
        body: Data? = nil,
        requestInterceptors: [RequestInterceptor] = [],
        responseInterceptors: [ResponseInterceptor] = [],
        completion: @escaping (Result<Data, APIError>) -> Void
    ) {
        request(
            url: url,
            method: .post,
            headers: headers,
            body: body,
            requestInterceptors: requestInterceptors,
            responseInterceptors: responseInterceptors,
            completion: completion
        )
    }
    
    /// Convenience PUT wrapper around `request(...)`.
    public func put(
        url: URL,
        headers: [String: String] = [:],
        body: Data? = nil,
        requestInterceptors: [RequestInterceptor] = [],
        responseInterceptors: [ResponseInterceptor] = [],
        completion: @escaping (Result<Data, APIError>) -> Void
    ) {
        request(
            url: url,
            method: .put,
            headers: headers,
            body: body,
            requestInterceptors: requestInterceptors,
            responseInterceptors: responseInterceptors,
            completion: completion
        )
    }
    
    /// Convenience DELETE wrapper around `request(...)`.
    public func delete(
        url: URL,
        headers: [String: String] = [:],
        requestInterceptors: [RequestInterceptor] = [],
        responseInterceptors: [ResponseInterceptor] = [],
        completion: @escaping (Result<Data, APIError>) -> Void
    ) {
        request(
            url: url,
            method: .delete,
            headers: headers,
            body: nil,
            requestInterceptors: requestInterceptors,
            responseInterceptors: responseInterceptors,
            completion: completion
        )
    }
}


