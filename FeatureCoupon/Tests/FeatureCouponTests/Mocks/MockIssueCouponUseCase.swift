import Foundation
@testable import FeatureCoupon

final class MockIssueCouponUseCase: IssueCouponUseCaseProtocol {
    
    var resultToReturn: (Bool, String) = (true, "Success")
    var shouldThrow: Bool = false
    
    func execute(args: FeatureCoupon.IssueCouponInput) async throws -> (success: Bool, message: String) {
        if shouldThrow { throw NSError(domain: "TestError", code: -1) }
        return resultToReturn
    }
}

