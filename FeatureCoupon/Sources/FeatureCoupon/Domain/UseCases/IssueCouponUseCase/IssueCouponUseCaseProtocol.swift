import Foundation

public protocol IssueCouponUseCaseProtocol {
    @MainActor
    func execute(
        args: IssueCouponInput
    ) async throws -> (success: Bool, message: String)
}

