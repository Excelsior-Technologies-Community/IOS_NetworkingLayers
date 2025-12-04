//
//  ContentView.swift
//  Networking Layer
//
//  Created by Noman Belim on 04/12/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let message = viewModel.errorMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .padding(.bottom, 8)
                }
                
                List(viewModel.products) { product in
                    Text(product.title)
                }
            }
            .navigationTitle("Products")
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }
}
