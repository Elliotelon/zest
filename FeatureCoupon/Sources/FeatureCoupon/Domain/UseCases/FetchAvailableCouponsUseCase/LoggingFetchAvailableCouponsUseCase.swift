import Foundation
import ZestCore

public final class LoggingFetchAvailableCouponsUseCase: FetchAvailableCouponsUseCaseProtocol {
    
    private let loggingUseCase: LoggingUseCase<FetchAvailableCouponsUseCase>
    
    public init(
        decorated: FetchAvailableCouponsUseCase,
        logger: any Logger,
        screen: String? = nil
    ) {
        self.loggingUseCase = LoggingUseCase(decorated: decorated, logger: logger, screen: screen)
    }
    
    @MainActor
    public func execute(args: FetchAvailableCouponsInput) async throws -> [Coupon] {
        try await loggingUseCase.execute(args: args)
    }
}
