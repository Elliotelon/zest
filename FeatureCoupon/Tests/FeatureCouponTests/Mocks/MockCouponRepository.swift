import Foundation
@testable import FeatureCoupon

actor MockCouponRepository: CouponRepositoryProtocol {
    
    private(set) var availableCoupons: [Coupon] = []
    private(set) var userCoupons: [UserCoupon] = []
    
    private(set) var issueCouponCallCount = 0
    private(set) var maxCouponCount = 100
    private(set) var currentIssuedCount = 0
    private(set) var issuedProfileIds: Set<UUID> = []
    private(set) var delaySeconds: Double = 0.0
    
    // MARK: - Setters
    
    func setAvailableCoupons(_ coupons: [Coupon]) {
        self.availableCoupons = coupons
    }
    
    func setUserCoupons(_ coupons: [UserCoupon]) {
        self.userCoupons = coupons
    }
    
    func setMaxCouponCount(_ count: Int) {
        self.maxCouponCount = count
    }
    
    func setCurrentIssuedCount(_ count: Int) {
        self.currentIssuedCount = count
    }
    
    func setIssuedProfileIds(_ profileId: UUID) {
        self.issuedProfileIds.insert(profileId)
    }
    
    func setDelaySeconds(_ seconds: Double) {
        self.delaySeconds = seconds
    }
    
    // MARK: - Repository Methods
    
    func fetchAvailableCoupons() async throws -> [Coupon] {
        if delaySeconds > 0 {
            try await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
        }
        return availableCoupons
    }
    
    func fetchUserCoupons(profileId: UUID) async throws -> [UserCoupon] {
        return userCoupons
    }
    
    func fetchCoupon(id: UUID) async throws -> Coupon {
        Coupon(
            id: id,
            name: "테스트 쿠폰",
            discountRate: 10.0,
            maxCount: maxCouponCount,
            issuedCount: currentIssuedCount,
            isActive: true,
            createdAt: Date()
        )
    }
    
    func issueCoupon(profileId: UUID, couponId: UUID) async throws -> (success: Bool, message: String) {
        if delaySeconds > 0 {
            try await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
        }
        
        issueCouponCallCount += 1
        
        if issuedProfileIds.contains(profileId) {
            return (false, "이미 발급받은 쿠폰입니다.")
        }
        
        if currentIssuedCount >= maxCouponCount {
            return (false, "쿠폰이 모두 소진되었습니다.")
        }
        
        currentIssuedCount += 1
        issuedProfileIds.insert(profileId)
        
        return (true, "쿠폰 발급 성공")
    }
    
    func useCoupon(userCouponId: UUID, productId: UUID) async throws {
        // no-op
    }
}

