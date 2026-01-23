//
//  FetchAvailableCouponsUseCase.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

/// 사용 가능한 쿠폰 목록을 가져오는 UseCase
final class FetchAvailableCouponsUseCase: Sendable {
    private let repository: CouponRepositoryProtocol
    
    init(repository: CouponRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Coupon] {
        return try await repository.fetchAvailableCoupons()
    }
}
