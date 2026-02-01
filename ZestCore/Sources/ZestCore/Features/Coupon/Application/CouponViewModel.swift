import SwiftUI
import Combine

@MainActor
public final class CouponViewModel: ObservableObject {
    @Published public var couponScreenState = CouponScreenState()
    
    @Published public var availableCoupons: [Coupon] = []
    @Published public var userCoupons: [UserCoupon] = []
//    @Published public var isLoading = false
//    @Published public var isIssuing = false // 쿠폰 발급 중 여부 (중복 방지)
//    @Published public var errorMessage: String?
//    @Published public var successMessage: String?
    
    public let fetchAvailableCouponsUseCase: FetchAvailableCouponsUseCaseProtocol

    public let fetchUserCouponsUseCase: FetchUserCouponsUseCase
    public let issueCouponUseCase: IssueCouponUseCase
    
    init(
        fetchAvailableCouponsUseCase: FetchAvailableCouponsUseCaseProtocol,
        fetchUserCouponsUseCase: FetchUserCouponsUseCase,
        issueCouponUseCase: IssueCouponUseCase
    ) {
        self.fetchAvailableCouponsUseCase = fetchAvailableCouponsUseCase
        self.fetchUserCouponsUseCase = fetchUserCouponsUseCase
        self.issueCouponUseCase = issueCouponUseCase
    }
    
    /// 사용 가능한 쿠폰 목록을 로드합니다.
    public func loadAvailableCoupons() async {
        guard !couponScreenState.isLoading else { return }
        
        couponScreenState.isLoading = true
        couponScreenState.errorMessage = nil
        
        do {
            self.availableCoupons = try await fetchAvailableCouponsUseCase.execute(args: FetchAvailableCouponsInput())
            print("✅ 쿠폰 목록 로드 성공: \(availableCoupons.count)개")
        } catch {
            couponScreenState.errorMessage = error.localizedDescription
            print("❌ 쿠폰 목록 로드 실패: \(error)")
        }
        
        couponScreenState.isLoading = false
    }
    
    /// 사용자가 보유한 쿠폰 목록을 로드합니다.
    public func loadUserCoupons(profileId: UUID) async {
        do {
            userCoupons = try await fetchUserCouponsUseCase.execute(profileId: profileId)
            print("✅ 내 쿠폰 목록 로드 성공: \(userCoupons.count)개")
        } catch {
            couponScreenState.errorMessage = error.localizedDescription
            print("❌ 내 쿠폰 목록 로드 실패: \(error)")
        }
    }
    
    /// 쿠폰을 발급받습니다. (동시성 제어 적용)
    /// - Parameters:
    ///   - profileId: 사용자 ID
    ///   - couponId: 쿠폰 ID
    public func issueCoupon(profileId: UUID, couponId: UUID) async {
        // 중복 요청 방지
        guard !couponScreenState.isIssuing else {
            print("⚠️ 이미 쿠폰 발급 처리 중입니다.")
            return
        }
        
        couponScreenState.isIssuing = true
        couponScreenState.errorMessage = nil
        couponScreenState.successMessage = nil
        
        do {
            let (success, message) = try await issueCouponUseCase.execute(
                profileId: profileId,
                couponId: couponId
            )
            
            if success {
                couponScreenState.successMessage = message
                print("✅ \(message)")
                
                // 쿠폰 목록 새로고침
                await loadAvailableCoupons()
                await loadUserCoupons(profileId: profileId)
            } else {
                couponScreenState.errorMessage = message
                print("❌ \(message)")
            }
        } catch {
            couponScreenState.errorMessage = "쿠폰 발급 중 오류가 발생했습니다: \(error.localizedDescription)"
            print("❌ 쿠폰 발급 실패: \(error)")
        }
        
        couponScreenState.isIssuing = false
    }
    
    /// 특정 쿠폰을 이미 보유하고 있는지 확인합니다.
    public func hasUserCoupon(couponId: UUID) -> Bool {
        return userCoupons.contains { $0.couponId == couponId }
    }
}
