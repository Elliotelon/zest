import Foundation
@testable import FeatureCoupon

final class MockFetchUserCouponsUseCase: FetchUserCouponsUseCaseProtocol {
    var userCouponsToReturn: [UserCoupon] = []
    var shouldThrow: Bool = false
    
    func execute(args: UUID) async throws -> [UserCoupon] {
        if shouldThrow { throw NSError(domain: "TestError", code: -1) }
        return userCouponsToReturn
    }
}

