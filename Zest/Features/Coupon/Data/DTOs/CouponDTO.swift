//
//  CouponDTO.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Foundation

/// 쿠폰 DTO
struct CouponDTO: Codable {
    let id: UUID
    let name: String
    let discountRate: Double
    let maxCount: Int
    let issuedCount: Int
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
    
    func toEntity() -> Coupon {
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
struct UserCouponDTO: Codable {
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
    
    func toEntity() -> UserCoupon {
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
struct IssueCouponResponseDTO: Codable {
    let success: Bool
    let error: String?
    let message: String?
    let coupon: CouponInResponse?
    
    struct CouponInResponse: Codable {
        let id: UUID
        let name: String
        let discountRate: Double
        let issuedCount: Int
        let maxCount: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case discountRate = "discount_rate"
            case issuedCount = "issued_count"
            case maxCount = "max_count"
        }
    }
}
