import Foundation
import ZestCore

public final class FetchUserCouponsUseCase: FetchUserCouponsUseCaseProtocol, DynamicExecutable, Sendable {
    
    public typealias Input = UUID
    
    public typealias Output = [UserCoupon]
    
    private let repository: any CouponRepositoryProtocol
    
    public init(repository: some CouponRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(args: Input) async throws -> Output {
        return try await repository.fetchUserCoupons(profileId: args)
    }
}
