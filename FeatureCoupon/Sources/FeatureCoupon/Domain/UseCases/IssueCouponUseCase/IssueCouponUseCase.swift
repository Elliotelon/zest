import Foundation
import ZestCore

public struct IssueCouponInput: Sendable {
    public let profileId: UUID
    public let couponId: UUID
    
    public init(profileId: UUID, couponId: UUID) {
        self.profileId = profileId
        self.couponId = couponId
    }
}

public actor IssueCouponUseCase: IssueCouponUseCaseProtocol, DynamicExecutable, Sendable {
    
    
    public typealias Input = IssueCouponInput
    
    public typealias Output = (success: Bool, message: String)
    
    
    private let repository: any CouponRepositoryProtocol
    private var isIssuing: Bool = false
    
    public init(repository: some CouponRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(args: IssueCouponInput) async throws -> Output {
        // ✅ 중복 요청 차단
        guard !isIssuing else {
            return (false, "이미 쿠폰 발급 처리 중입니다.")
        }
        
        isIssuing = true
        defer { isIssuing = false }
        
        return try await repository.issueCoupon(
            profileId: args.profileId,
            couponId: args.couponId
        )
    }
}

