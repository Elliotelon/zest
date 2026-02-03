import Foundation
import ZestCore

public final class LoggingFetchUserCouponsUseCase: FetchUserCouponsUseCaseProtocol {
    
    private let loggingUseCase: LoggingUseCase<FetchUserCouponsUseCase>
    
    public init(
        decorated: FetchUserCouponsUseCase,
        logger: any Logger,
        screen: String? = nil
    ) {
        self.loggingUseCase = LoggingUseCase(decorated: decorated, logger: logger, screen: screen)
    }
    
    @MainActor
    public func execute(args: UUID) async throws -> [UserCoupon] {
        try await loggingUseCase.execute(args: args)
    }
}
