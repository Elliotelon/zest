//
//  FetchUserCouponsUseCase.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

public final class FetchUserCouponsUseCase: Sendable {
    private let repository: any CouponRepositoryProtocol
    
    public init(repository: some CouponRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(profileId: UUID) async throws -> [UserCoupon] {
        return try await repository.fetchUserCoupons(profileId: profileId)
    }
}
