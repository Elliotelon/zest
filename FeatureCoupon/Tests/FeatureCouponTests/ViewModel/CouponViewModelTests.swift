import Testing
import Foundation
@testable import FeatureCoupon

@Suite("CouponViewModel 테스트")
@MainActor
struct CouponViewModelTests {
    
    // MARK: - Properties
    private var viewModel: CouponViewModel!
    
    // Mock UseCase
    private var fetchAvailableCouponsUseCase: MockFetchAvailableCouponsUseCase!
    private var fetchUserCouponsUseCase: MockFetchUserCouponsUseCase!
    private var issueCouponUseCase: MockIssueCouponUseCase!
    
    private let testProfileId = UUID()
    private let testCouponId = UUID()
    
    // Swift-Testing 초기화
    init() async throws {
        fetchAvailableCouponsUseCase = MockFetchAvailableCouponsUseCase()
        fetchUserCouponsUseCase = MockFetchUserCouponsUseCase()
        issueCouponUseCase = MockIssueCouponUseCase()
        
        viewModel = CouponViewModel(
            fetchAvailableCouponsUseCase: fetchAvailableCouponsUseCase,
            fetchUserCouponsUseCase: fetchUserCouponsUseCase,
            issueCouponUseCase: issueCouponUseCase
        )
    }
    
    // MARK: - Tests
    @Test("사용 가능한 쿠폰 로드 성공")
    func loadAvailableCouponsSuccess() async throws {
        // Given
        let expectedCoupons = [
            Coupon(
                id: testCouponId,
                name: "10% 할인",
                discountRate: 10.0,
                maxCount: 100,
                issuedCount: 0,
                isActive: true,
                createdAt: Date()
            )
        ]
        fetchAvailableCouponsUseCase.couponsToReturn = expectedCoupons
        
        // When
        await viewModel.loadAvailableCoupons()
        
        // Then
        if case let .content(available, _) = viewModel.state {
            #expect(available.count == 1)
            #expect(available.first?.name == "10% 할인")
        } else {
            #expect(false)
        }
    }
    
    @Test("사용 가능한 쿠폰 로드 실패")
    func loadAvailableCouponsFailure() async throws {
        // Given
        fetchAvailableCouponsUseCase.shouldThrow = true
        
        // When
        await viewModel.loadAvailableCoupons()
        
        // Then
        if case .error = viewModel.state {
            #expect(true)
        } else {
            #expect(false)
        }
    }
    
    @Test("사용자 쿠폰 로드 성공")
    func loadUserCouponsSuccess() async throws {
        // Given
        let userCoupon = UserCoupon(
            id: UUID(),
            profileId: testProfileId,
            couponId: testCouponId,
            issuedAt: Date(),
            usedAt: nil,
            productId: nil
        )
        fetchUserCouponsUseCase.userCouponsToReturn = [userCoupon]
        
        // When
        await viewModel.loadUserCoupons(profileId: testProfileId)
        
        // Then
        if case let .content(_, user) = viewModel.state {
            #expect(user.count == 1)
            #expect(user.first?.couponId == testCouponId)
        } else {
            #expect(false)
        }
    }
    
    @Test("쿠폰 발급 성공 시 상태 반영")
    func issueCouponSuccess() async throws {
        // Given
        issueCouponUseCase.resultToReturn = (true, "쿠폰 발급 성공")
        fetchAvailableCouponsUseCase.couponsToReturn = []
        fetchUserCouponsUseCase.userCouponsToReturn = []
        
        // When
        await viewModel.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        #expect(viewModel.toastMessage == "쿠폰 발급 성공")
        #expect(viewModel.isIssuing == false)
    }
    
    @Test("쿠폰 발급 실패 시 상태 반영")
    func issueCouponFailure() async throws {
        // Given
        issueCouponUseCase.resultToReturn = (false, "발급 불가")
        
        // When
        await viewModel.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        #expect(viewModel.toastMessage == "발급 불가")
        #expect(viewModel.isIssuing == false)
    }
    
    @Test("쿠폰 발급 중복 요청 방지")
    func issueCouponWhileIssuing() async throws {
        // Given
        viewModel.isIssuing = true
        
        // When
        await viewModel.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        #expect(viewModel.toastMessage == nil)
    }
    
    @Test("hasUserCoupon 확인")
    func hasUserCouponCheck() async throws {
        // Given
        let userCoupon = UserCoupon(
            id: UUID(),
            profileId: testProfileId,
            couponId: testCouponId,
            issuedAt: Date(),
            usedAt: nil,
            productId: nil
        )
        
        // Then
        #expect(viewModel.hasUserCoupon(couponId: testCouponId, in: [userCoupon]) == true)
        #expect(viewModel.hasUserCoupon(couponId: UUID(), in: [userCoupon]) == false)
    }
}
