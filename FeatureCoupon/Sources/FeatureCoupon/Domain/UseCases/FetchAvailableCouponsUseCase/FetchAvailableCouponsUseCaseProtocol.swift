public protocol FetchAvailableCouponsUseCaseProtocol {
    @MainActor
    func execute(args: FetchAvailableCouponsInput) async throws -> [Coupon]
}


