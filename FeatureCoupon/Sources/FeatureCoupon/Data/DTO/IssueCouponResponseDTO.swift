import Foundation

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

