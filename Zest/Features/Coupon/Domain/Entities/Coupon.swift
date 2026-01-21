//
//  Coupon.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

/// 쿠폰 엔티티
struct Coupon: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let discountRate: Double // 할인율 (예: 10.0 = 10%)
    let maxCount: Int // 최대 발급 가능 수량
    let issuedCount: Int // 현재 발급된 수량
    let isActive: Bool
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case discountRate = "discount_rate"
        case maxCount = "max_count"
        case issuedCount = "issued_count"
        case isActive = "is_active"
        case createdAt = "created_at"
    }
    
    /// 쿠폰이 소진되었는지 확인
    var isExhausted: Bool {
        return issuedCount >= maxCount
    }
    
    /// 남은 쿠폰 수량
    var remainingCount: Int {
        return max(0, maxCount - issuedCount)
    }
    
    /// 할인된 가격 계산
    func discountedPrice(from originalPrice: Double) -> Double {
        return originalPrice * (1 - discountRate / 100)
    }
}

/// 사용자별 쿠폰 발급 내역
struct UserCoupon: Identifiable, Codable, Equatable {
    let id: UUID
    let profileId: UUID
    let couponId: UUID
    let issuedAt: Date
    let usedAt: Date?
    let productId: UUID?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileId = "profile_id"
        case couponId = "coupon_id"
        case issuedAt = "issued_at"
        case usedAt = "used_at"
        case productId = "product_id"
    }
    
    /// 쿠폰이 사용되었는지 확인
    var isUsed: Bool {
        return usedAt != nil
    }
}
