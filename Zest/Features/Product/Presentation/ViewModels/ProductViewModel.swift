//
//  ProductViewModel.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import SwiftUI
import Combine

@MainActor
final class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fetchProductsUseCase: FetchProductsUseCase
    
    init(fetchProductsUseCase: FetchProductsUseCase) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await fetchProductsUseCase.execute()
            print("✅ 상품 데이터 로드 성공: \(products.count)개")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 상품 데이터 로드 실패: \(error)")
        }
        
        isLoading = false
    }
}
