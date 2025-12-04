//
//  ProductViewModel.swift
//  Networking Layer
//
//  Created by Noman Belim on 04/12/25.
//

import SwiftUI
import Foundation
import Combine

class ProductViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var errorMessage: String?
    private let api = APIService.shared
    
    func fetchProducts() {
        Logger.log("🔔 fetchProducts started")

        // Interceptors: add headers and log responses
        let authInterceptor = AuthInterceptor(token: "my-demo-token")
        let headerInterceptor = DebugHeaderInterceptor()
        let responseInterceptor = DebugResponseInterceptor()

        api.get(
            url: APIEndpoint.products.url,
            requestInterceptors: [authInterceptor, headerInterceptor],
            responseInterceptors: [responseInterceptor]
        ) { [weak self] result in
            switch result {
            case .success(let data):
                Logger.log("✅ fetchProducts success, data bytes: \(data.count)")
                self?.decodeProducts(data)
            case .failure(let error):
                Logger.log("❌ fetchProducts failed: \(error)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Something went wrong: \(error)"
                }
            }
        }
    }
    
    private func decodeProducts(_ data: Data) {
        do {
            let items = try JSONDecoder().decode([Product].self, from: data)
            DispatchQueue.main.async {
                self.products = items
                self.errorMessage = nil
            }
        } catch {
            Logger.log("❌ Decoding failed: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load products."
            }
        }
    }
    
    private func loadDummyProducts() {
        decodeProducts(DummyResponse.products)
    }
}

