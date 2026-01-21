//
//  CouponRepositoryProtocol.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

protocol CouponRepositoryProtocol {
    /// 사용 가능한 모든 쿠폰 목록을 가져옵니다.
    func fetchAvailableCoupons() async throws -> [Coupon]
    
    /// 특정 쿠폰 정보를 가져옵니다.
    func fetchCoupon(id: UUID) async throws -> Coupon
    
    /// 쿠폰을 발급받습니다. (동시성 제어 적용)
    /// - Parameters:
    ///   - profileId: 사용자 ID
    ///   - couponId: 쿠폰 ID
    /// - Returns: (성공 여부, 메시지)
    func issueCoupon(profileId: UUID, couponId: UUID) async throws -> (success: Bool, message: String)
    
    /// 사용자가 보유한 쿠폰 목록을 가져옵니다.
    func fetchUserCoupons(profileId: UUID) async throws -> [UserCoupon]
    
    /// 쿠폰을 사용합니다.
    /// - Parameters:
    ///   - userCouponId: 사용자 쿠폰 ID
    ///   - productId: 적용할 상품 ID
    func useCoupon(userCouponId: UUID, productId: UUID) async throws
}
