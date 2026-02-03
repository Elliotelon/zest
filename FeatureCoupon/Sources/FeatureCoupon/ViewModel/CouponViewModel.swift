import SwiftUI

@MainActor
public final class CouponViewModel: ObservableObject {
    
    // MARK: - State
    @Published public var state: CouponViewState = .idle
    @Published public var toastMessage: String?
    @Published public var isIssuing: Bool = false
    
    // MARK: - UseCases
    private let fetchAvailableCouponsUseCase: FetchAvailableCouponsUseCaseProtocol
    private let fetchUserCouponsUseCase: FetchUserCouponsUseCaseProtocol
    private let issueCouponUseCase: IssueCouponUseCaseProtocol
    
    public init(
        fetchAvailableCouponsUseCase: FetchAvailableCouponsUseCaseProtocol,
        fetchUserCouponsUseCase: FetchUserCouponsUseCaseProtocol,
        issueCouponUseCase: IssueCouponUseCaseProtocol
    ) {
        self.fetchAvailableCouponsUseCase = fetchAvailableCouponsUseCase
        self.fetchUserCouponsUseCase = fetchUserCouponsUseCase
        self.issueCouponUseCase = issueCouponUseCase
    }
    
    // MARK: - Load Available Coupons
    public func loadAvailableCoupons() async {
        state = .loading
        do {
            let available = try await fetchAvailableCouponsUseCase.execute(args: FetchAvailableCouponsInput())
            let user = currentUserCoupons()
            
            if available.isEmpty && user.isEmpty {
                state = .empty
            } else {
                state = .content(availableCoupons: available, userCoupons: user)
            }
        } catch {
            state = .error(.server)
        }
    }
    
    // MARK: - Load User Coupons
    public func loadUserCoupons(profileId: UUID) async {
        do {
            let user = try await fetchUserCouponsUseCase.execute(args: profileId)
            let available = currentAvailableCoupons()
            
            if available.isEmpty && user.isEmpty {
                state = .empty
            } else {
                state = .content(availableCoupons: available, userCoupons: user)
            }
        } catch {
            state = .error(.server)
        }
    }
    
    // MARK: - Issue Coupon
    public func issueCoupon(profileId: UUID, couponId: UUID) async {
        guard !isIssuing else { return }
        isIssuing = true
        toastMessage = nil
        
        do {
            let (success, message) = try await issueCouponUseCase.execute(
                args: IssueCouponInput(profileId: profileId, couponId: couponId)
            )
            
            toastMessage = message
            
            if success {
                await loadAvailableCoupons()
                await loadUserCoupons(profileId: profileId)
            }
        } catch {
            toastMessage = "쿠폰 발급 중 오류가 발생했습니다."
        }
        
        isIssuing = false
    }
    
    // MARK: - Helper
    public func hasUserCoupon(couponId: UUID, in userCoupons: [UserCoupon]) -> Bool {
        userCoupons.contains { $0.couponId == couponId }
    }
    
    // MARK: - Private Helpers
    private func currentAvailableCoupons() -> [Coupon] {
        if case let .content(available, _) = state {
            return available
        }
        return []
    }
    
    private func currentUserCoupons() -> [UserCoupon] {
        if case let .content(_, user) = state {
            return user
        }
        return []
    }
}
