//
//  FetchProductsUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

/// 상품 목록을 가져오는 UseCase
final class FetchProductsUseCase {
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Product] {
        return try await repository.fetchProducts()
    }
}
