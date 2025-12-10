//
//  NetworkCaller.swift
//  NetworkingLayer
//

import Foundation

public final class NetworkCaller {

    private let api = APIService.shared

    /// Universal API caller — super easy to use in any project.
    ///
    /// Example:
    /// callAPI(url: "https://test.com", method: .get) { result in ... }
    ///
    public func callAPI(
        url: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        body: [String: Any]? = nil,
        completion: @escaping (Result<Data, APIError>) -> Void
    ) {
        guard let url = URL(string: url) else {
            return completion(.failure(.network("Invalid URL")))
        }
        
        // Convert body dictionary to JSON
        var httpBody: Data? = nil
        if let body = body {
            httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        // Use your existing APIService
        api.request(
            url: url,
            method: method,
            headers: headers,
            body: httpBody,
            requestInterceptors: [],     // no interceptors needed unless user wants
            responseInterceptors: [],
            completion: completion
        )
    }

    /// Helper: Direct JSON decode into any Decodable struct
    public func callAPI<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        body: [String: Any]? = nil,
        decodeType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        callAPI(url: url, method: method, headers: headers, body: body) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decoding(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
