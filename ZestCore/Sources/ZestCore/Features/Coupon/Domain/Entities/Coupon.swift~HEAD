//
//  Coupon.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

/// 쿠폰 엔티티
public struct Coupon: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let name: String
    public let discountRate: Double // 할인율 (예: 10.0 = 10%)
    public let maxCount: Int // 최대 발급 가능 수량
    public let issuedCount: Int // 현재 발급된 수량
    public let isActive: Bool
    public let createdAt: Date
    
    public init(id: UUID, name: String, discountRate: Double, maxCount: Int, issuedCount: Int, isActive: Bool, createdAt: Date) {
        self.id = id
        self.name = name
        self.discountRate = discountRate
        self.maxCount = maxCount
        self.issuedCount = issuedCount
        self.isActive = isActive
        self.createdAt = createdAt
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case discountRate = "discount_rate"
        case maxCount = "max_count"
        case issuedCount = "issued_count"
        case isActive = "is_active"
        case createdAt = "created_at"
    }
    
    /// 쿠폰이 소진되었는지 확인
    public var isExhausted: Bool {
        return issuedCount >= maxCount
    }
    
    /// 남은 쿠폰 수량
    public var remainingCount: Int {
        return max(0, maxCount - issuedCount)
    }
    
    /// 할인된 가격 계산
    public func discountedPrice(from originalPrice: Double) -> Double {
        return originalPrice * (1 - discountRate / 100)
    }
}

/// 사용자별 쿠폰 발급 내역
public struct UserCoupon: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let profileId: UUID
    public let couponId: UUID
    public let issuedAt: Date
    public let usedAt: Date?
    public let productId: UUID?
    
    public init(id: UUID, profileId: UUID, couponId: UUID, issuedAt: Date, usedAt: Date?, productId: UUID?) {
        self.id = id
        self.profileId = profileId
        self.couponId = couponId
        self.issuedAt = issuedAt
        self.usedAt = usedAt
        self.productId = productId
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case profileId = "profile_id"
        case couponId = "coupon_id"
        case issuedAt = "issued_at"
        case usedAt = "used_at"
        case productId = "product_id"
    }
    
    /// 쿠폰이 사용되었는지 확인
    public var isUsed: Bool {
        return usedAt != nil
    }
}
