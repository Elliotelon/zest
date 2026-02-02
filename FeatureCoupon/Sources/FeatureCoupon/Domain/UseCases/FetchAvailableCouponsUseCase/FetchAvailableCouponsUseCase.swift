import Foundation
import ZestCore

public struct FetchAvailableCouponsInput: Sendable {
    public init(){}
}

public final class FetchAvailableCouponsUseCase: FetchAvailableCouponsUseCaseProtocol, DynamicExecutable, Sendable {
    public typealias Input = FetchAvailableCouponsInput
    public typealias Output = [Coupon]
    
    private let repository: any CouponRepositoryProtocol
    
    public init(repository: any CouponRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(args: Input) async throws -> [Coupon] {
        try await repository.fetchAvailableCoupons()
    }
}
