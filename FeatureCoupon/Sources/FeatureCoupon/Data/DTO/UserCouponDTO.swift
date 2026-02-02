import Foundation

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
