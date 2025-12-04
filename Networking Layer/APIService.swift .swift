//
//  APIService.swift .swift
//  Networking Layer
//
//  Created by Noman Belim on 04/12/25.
//
import Foundation

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

// MARK: - Interceptors

/// Allows you to modify a request before it is sent (e.g. add auth headers).
protocol RequestInterceptor {
    func intercept(_ request: URLRequest) -> URLRequest
}

/// Allows you to observe / react to every response (e.g. global logging, token refresh).
protocol ResponseInterceptor {
    func intercept(data: Data?, response: URLResponse?, error: Error?)
}

// MARK: - API Service (Reusable Networking Layer)

class APIService {
    
    static let shared = APIService()
    private init() {}
    
    private let session: URLSession = .shared
    
    /// Low‑level, reusable request handler that supports all HTTP methods.
    func request(
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
    
    func get(
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
    
    func post(
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
    
    func put(
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
    
    func delete(
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

