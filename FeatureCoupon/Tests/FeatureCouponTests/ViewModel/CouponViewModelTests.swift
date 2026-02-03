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
    
    // Swift-Testing 초기화 (XCTest setUp과 유사)
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
            Coupon(id: testCouponId, name: "10% 할인", discountRate: 10.0, maxCount: 100, issuedCount: 0, isActive: true, createdAt: Date())
        ]
        fetchAvailableCouponsUseCase.couponsToReturn = expectedCoupons
        
        // When
        await viewModel.loadAvailableCoupons()
        
        // Then
        #expect(viewModel.availableCoupons.count == 1)
        #expect(viewModel.availableCoupons.first?.name == "10% 할인")
        #expect(viewModel.couponScreenState.isLoading == false)
        #expect(viewModel.couponScreenState.errorMessage == nil)
    }
    
    @Test("사용 가능한 쿠폰 로드 실패")
    func loadAvailableCouponsFailure() async throws {
        // Given
        fetchAvailableCouponsUseCase.shouldThrow = true
        
        // When
        await viewModel.loadAvailableCoupons()
        
        // Then
        #expect(viewModel.availableCoupons.isEmpty)
        #expect(viewModel.couponScreenState.isLoading == false)
        #expect(viewModel.couponScreenState.errorMessage != nil)
    }
    
    @Test("사용자 쿠폰 로드 성공")
    func loadUserCouponsSuccess() async throws {
        // Given
        let userCoupon = UserCoupon(id: UUID(), profileId: testProfileId, couponId: testCouponId, issuedAt: Date(), usedAt: nil, productId: nil)
        fetchUserCouponsUseCase.userCouponsToReturn = [userCoupon]
        
        // When
        await viewModel.loadUserCoupons(profileId: testProfileId)
        
        // Then
        #expect(viewModel.userCoupons.count == 1)
        #expect(viewModel.userCoupons.first?.couponId == testCouponId)
    }
    
    @Test("쿠폰 발급 성공 시 상태 반영")
    func issueCouponSuccess() async throws {
        // Given
        issueCouponUseCase.resultToReturn = (true, "쿠폰 발급 성공")
        
        // When
        await viewModel.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        #expect(viewModel.couponScreenState.successMessage == "쿠폰 발급 성공")
        #expect(viewModel.couponScreenState.errorMessage == nil)
        #expect(viewModel.couponScreenState.isIssuing == false)
    }
    
    @Test("쿠폰 발급 실패 시 상태 반영")
    func issueCouponFailure() async throws {
        // Given
        issueCouponUseCase.resultToReturn = (false, "발급 불가")
        
        // When
        await viewModel.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        #expect(viewModel.couponScreenState.successMessage == nil)
        #expect(viewModel.couponScreenState.errorMessage == "발급 불가")
        #expect(viewModel.couponScreenState.isIssuing == false)
    }
    
    @Test("쿠폰 발급 중복 요청 방지")
    func issueCouponWhileIssuing() async throws {
        // Given
        viewModel.couponScreenState.isIssuing = true
        
        // When
        await viewModel.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        #expect(viewModel.couponScreenState.successMessage == nil)
        #expect(viewModel.couponScreenState.errorMessage == nil)
    }
    
    @Test("hasUserCoupon 확인")
    func hasUserCouponCheck() async throws {
        // Given
        let userCoupon = UserCoupon(id: UUID(), profileId: testProfileId, couponId: testCouponId, issuedAt: Date(), usedAt: nil, productId: nil)
        viewModel.userCoupons = [userCoupon]
        
        // Then
        #expect(viewModel.hasUserCoupon(couponId: testCouponId) == true)
        #expect(viewModel.hasUserCoupon(couponId: UUID()) == false)
    }
}

