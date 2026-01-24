//
//  CouponDTO.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

/// 쿠폰 DTO
public struct CouponDTO: Codable, Sendable  {
    public let id: UUID
    public let name: String
    public let discountRate: Double
    public let maxCount: Int
    public let issuedCount: Int
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
    
    public func toEntity() -> Coupon {
        return Coupon(
            id: id,
            name: name,
            discountRate: discountRate,
            maxCount: maxCount,
            issuedCount: issuedCount,
            isActive: isActive,
            createdAt: createdAt
        )
    }
}

/// 사용자 쿠폰 DTO
public struct UserCouponDTO: Codable, Sendable {
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
    
    public func toEntity() -> UserCoupon {
        return UserCoupon(
            id: id,
            profileId: profileId,
            couponId: couponId,
            issuedAt: issuedAt,
            usedAt: usedAt,
            productId: productId
        )
    }
}

/// 쿠폰 발급 RPC 응답 DTO
public struct IssueCouponResponseDTO: Codable, Sendable {
    public let success: Bool
    public let error: String?
    public let message: String?
    public let coupon: CouponInResponse?
    
    public init(success: Bool, error: String?, message: String?, coupon: CouponInResponse?) {
        self.success = success
        self.error = error
        self.message = message
        self.coupon = coupon
    }
    
    public struct CouponInResponse: Codable, Sendable {
        public let id: UUID
        public let name: String
        public let discountRate: Double
        public let issuedCount: Int
        public let maxCount: Int
        
        public init(id: UUID, name: String, discountRate: Double, issuedCount: Int, maxCount: Int) {
            self.id = id
            self.name = name
            self.discountRate = discountRate
            self.issuedCount = issuedCount
            self.maxCount = maxCount
        }
        
        public enum CodingKeys: String, CodingKey {
            case id
            case name
            case discountRate = "discount_rate"
            case issuedCount = "issued_count"
            case maxCount = "max_count"
        }
    }
}
