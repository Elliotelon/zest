import Foundation
@testable import FeatureCoupon

final class MockFetchAvailableCouponsUseCase: FetchAvailableCouponsUseCaseProtocol {
    var couponsToReturn: [Coupon] = []
    var shouldThrow: Bool = false
    
    func execute(args: FetchAvailableCouponsInput) async throws -> [Coupon] {
        if shouldThrow { throw NSError(domain: "TestError", code: -1) }
        return couponsToReturn
    }
}

