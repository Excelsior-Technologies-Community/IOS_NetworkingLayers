//
//  Logger.swift
//  NetworkingKit
//

import Foundation

/// Simple logging utility used across APIService and Interceptors.
public struct Logger {
    
    public static func log(_ message: String) {
        #if DEBUG
        print("🔎 [NetworkingKit] \(message)")
        #endif
    }
}
