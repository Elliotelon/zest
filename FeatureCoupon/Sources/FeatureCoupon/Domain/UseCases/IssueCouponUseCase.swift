import Foundation

public actor IssueCouponUseCase: Sendable {

    private let repository: any CouponRepositoryProtocol
    private var isIssuing: Bool = false

    public init(repository: some CouponRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(
        profileId: UUID,
        couponId: UUID
    ) async throws -> (success: Bool, message: String) {

        // ✅ 중복 요청 차단
        guard !isIssuing else {
            return (false, "이미 쿠폰 발급 처리 중입니다.")
        }

        isIssuing = true
        defer { isIssuing = false }

        return try await repository.issueCoupon(
            profileId: profileId,
            couponId: couponId
        )
    }
}

