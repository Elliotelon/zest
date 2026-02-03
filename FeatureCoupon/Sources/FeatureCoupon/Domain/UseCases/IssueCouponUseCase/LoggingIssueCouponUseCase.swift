import Foundation
import ZestCore

public final class LoggingIssueCouponUseCase: IssueCouponUseCaseProtocol {
    
    private let loggingUseCase: LoggingUseCase<IssueCouponUseCase>
    
    public init(
        decorated: IssueCouponUseCase,
        logger: any Logger,
        screen: String? = nil
    ) {
        self.loggingUseCase = LoggingUseCase(decorated: decorated, logger: logger, screen: screen)
    }
    
    @MainActor
    public func execute(args: IssueCouponInput) async throws -> (success: Bool, message: String) {
        try await loggingUseCase.execute(args: args)
    }
    
}

