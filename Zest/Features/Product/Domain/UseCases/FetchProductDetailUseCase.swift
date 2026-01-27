//
//  FetchProductDetailUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

/// 특정 상품의 상세 정보를 가져오는 UseCase
final class FetchProductDetailUseCase: Sendable {
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(productId: UUID) async throws -> Product {
        return try await repository.fetchProduct(id: productId)
    }
}
