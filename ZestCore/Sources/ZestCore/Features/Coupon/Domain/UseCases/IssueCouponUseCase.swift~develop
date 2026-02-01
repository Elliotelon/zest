import Foundation

public final class IssueCouponUseCase: Sendable {
    private let repository: any CouponRepositoryProtocol
    
    public init(repository: some CouponRepositoryProtocol) {
        self.repository = repository
    }
    
    /// 쿠폰을 발급받습니다.
    /// - Parameters:
    ///   - profileId: 사용자 ID
    ///   - couponId: 쿠폰 ID
    /// - Returns: (성공 여부, 메시지)
    public func execute(profileId: UUID, couponId: UUID) async throws -> (success: Bool, message: String) {
        return try await repository.issueCoupon(profileId: profileId, couponId: couponId)
    }
}
