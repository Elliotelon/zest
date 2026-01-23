//
//  FetchProductsUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

/// 상품 목록을 가져오는 UseCase
final class FetchProductsUseCase: Sendable {
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Product] {
        return try await repository.fetchProducts()
    }
    
    /// 페이지네이션을 지원하는 상품 목록 가져오기
    /// - Parameters:
    ///   - offset: 시작 인덱스
    ///   - limit: 가져올 개수 (기본값: 20)
    /// - Returns: 상품 배열
    func execute(offset: Int, limit: Int = 20) async throws -> [Product] {
        return try await repository.fetchProducts(offset: offset, limit: limit)
    }
}
