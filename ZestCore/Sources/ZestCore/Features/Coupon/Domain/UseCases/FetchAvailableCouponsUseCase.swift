import Foundation

/// 사용 가능한 쿠폰 목록을 가져오는 UseCase
@MainActor
public final class FetchAvailableCouponsUseCase: Sendable {
    private let repository: any CouponRepositoryProtocol
    private let logger: any Logger
    
    public init(repository: any CouponRepositoryProtocol, logger: any Logger) {
        self.repository = repository
        self.logger = logger
    }
    
    /// 쿠폰 목록
    public func execute() async -> [Coupon] {
        let trace = TraceContext(traceId: UUID().uuidString)
        logger.info("FetchAvailableCoupons 시작", trace: trace)
        
        do {
            let coupons = try await repository.fetchAvailableCoupons()
            logger.info("FetchAvailableCoupons 성공: \(coupons.count)개", trace: trace)
            return coupons
        } catch {
            logger.error("FetchAvailableCoupons 실패", trace: trace, error: error)
            return []
        }
    }
}
