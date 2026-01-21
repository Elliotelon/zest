//
//  FetchUserCouponsUseCase.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

/// 사용자가 보유한 쿠폰 목록을 가져오는 UseCase
final class FetchUserCouponsUseCase {
    private let repository: CouponRepositoryProtocol
    
    init(repository: CouponRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(profileId: UUID) async throws -> [UserCoupon] {
        return try await repository.fetchUserCoupons(profileId: profileId)
    }
}
