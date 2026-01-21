//
//  FetchCartItemsUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

final class FetchCartItemsUseCase {
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(profileId: UUID) async throws -> [CartItem] {
        return try await repository.fetchCartItems(profileId: profileId)
    }
}
