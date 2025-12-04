//
//  Interceptors.swift
//  Networking Layer
//
//  Created by AI Helper.
//

import Foundation

/// Simple example: adds a debug header to every request.
public struct DebugHeaderInterceptor: RequestInterceptor {
    public init() {}
    
    public func intercept(_ request: URLRequest) -> URLRequest {
        var req = request
        req.addValue("12345", forHTTPHeaderField: "X-Debug-Id")
        Logger.log("🔧 DebugHeaderInterceptor added X-Debug-Id header")
        return req
    }
}

/// Real-world example: adds an Authorization header (for logged-in APIs).
public struct AuthInterceptor: RequestInterceptor {
    public let token: String   // in a real app, this comes from login / Keychain
    
    public init(token: String) {
        self.token = token
    }
    
    public func intercept(_ request: URLRequest) -> URLRequest {
        var req = request
        req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        Logger.log("🔐 AuthInterceptor added Authorization header")
        return req
    }
}

/// Simple example: logs status code or error for every response.
public struct DebugResponseInterceptor: ResponseInterceptor {
    public init() {}
    
    public func intercept(data: Data?, response: URLResponse?, error: Error?) {
        if let http = response as? HTTPURLResponse {
            Logger.log("🔍 DebugResponseInterceptor saw status: \(http.statusCode)")
        }
        if let error = error {
            Logger.log("🔍 DebugResponseInterceptor saw error: \(error.localizedDescription)")
        }
    }
}


