import Foundation

public protocol FetchUserCouponsUseCaseProtocol {
    @MainActor
    func execute(args: UUID) async throws -> [UserCoupon]
}

