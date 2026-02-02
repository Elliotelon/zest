import Foundation

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


