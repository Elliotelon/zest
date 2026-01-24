//
//  FetchAvailableCouponsUseCase.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

/// 사용 가능한 쿠폰 목록을 가져오는 UseCase
public final class FetchAvailableCouponsUseCase: Sendable {
    private let repository: any CouponRepositoryProtocol
    
    public init(repository: some CouponRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Coupon] {
        return try await repository.fetchAvailableCoupons()
    }
}
