import Testing
import Foundation
@testable import FeatureCoupon

@Suite("쿠폰 UseCase 비즈니스 로직 테스트")
@MainActor
struct CouponUseCaseTests {
    
    // MARK: - Properties
    
    private var mockRepository: MockCouponRepository
    private var fetchAvailableCouponsUseCase: FetchAvailableCouponsUseCase
    private var fetchUserCouponsUseCase: FetchUserCouponsUseCase
    private var issueCouponUseCase: IssueCouponUseCase
    
    private let testCouponId = UUID()
    private let testProfileId = UUID()
    
    // Swift Testing init == XCTest setUp
    init() async throws {
        let repository = MockCouponRepository()
        self.mockRepository = repository
        
        self.fetchAvailableCouponsUseCase = FetchAvailableCouponsUseCase(repository: repository)
        self.fetchUserCouponsUseCase = FetchUserCouponsUseCase(repository: repository)
        self.issueCouponUseCase = IssueCouponUseCase(repository: repository)
    }
    
    // MARK: - 시나리오 1: 사용 가능한 쿠폰 조회
    
    @Test("사용 가능한 쿠폰 목록 조회 성공")
    func fetchAvailableCouponsSuccess() async throws {
        // Given
        let expectedCoupons = [
            Coupon(
                id: UUID(),
                name: "테스트 쿠폰 1",
                discountRate: 10.0,
                maxCount: 100,
                issuedCount: 50,
                isActive: true,
                createdAt: Date()
            ),
            Coupon(
                id: UUID(),
                name: "테스트 쿠폰 2",
                discountRate: 20.0,
                maxCount: 50,
                issuedCount: 10,
                isActive: true,
                createdAt: Date()
            )
        ]
        
        await mockRepository.setAvailableCoupons(expectedCoupons)
        
        // When
        let coupons = try await fetchAvailableCouponsUseCase.execute( args: FetchAvailableCouponsInput())
        
        // Then
        #expect(coupons.count == 2)
        #expect(coupons[0].name == "테스트 쿠폰 1")
        #expect(coupons[0].discountRate == 10.0)
    }
    
    // MARK: - 시나리오 2: 쿠폰 발급 성공
    
    @Test("쿠폰 발급 성공")
    func issueCouponSuccess() async throws {
        // Given
        await mockRepository.setMaxCouponCount(100)
        await mockRepository.setCurrentIssuedCount(50)
        
        // When
        let result = try await issueCouponUseCase.execute(
            args: IssueCouponInput(profileId: testProfileId, couponId: testCouponId)
        )
        
        let currentCount = await mockRepository.currentIssuedCount
        let issuedIds = await mockRepository.issuedProfileIds
        
        // Then
        #expect(result.success == true)
        #expect(currentCount == 51)
        #expect(issuedIds.contains(testProfileId))
    }
    
    // MARK: - 시나리오 3: 중복 요청 방지
    
    @Test("쿠폰 발급 중 중복 요청은 한 번만 처리된다")
    func issueCouponDeduplicatesWhileLoading() async throws {
        // Given
        await mockRepository.setDelaySeconds(0.3)
        
        // When (동시에 두 번 요청)
        async let first = issueCouponUseCase.execute(
            args: IssueCouponInput(profileId: testProfileId, couponId: testCouponId)
        )
        
        async let second = issueCouponUseCase.execute(
            args: IssueCouponInput(profileId: testProfileId, couponId: testCouponId)
        )
        
        _ = try await (first, second)
        
        // Then
        let callCount = await mockRepository.issueCouponCallCount
        #expect(callCount == 1)
    }
    
    // MARK: - 시나리오 4: 이미 발급된 쿠폰 차단
    
    @Test("이미 발급받은 유저는 재발급할 수 없다")
    func issueCouponAlreadyIssued() async throws {
        // Given
        await mockRepository.setMaxCouponCount(10)
        await mockRepository.setIssuedProfileIds(testProfileId)
        
        // When
        let result = try await issueCouponUseCase.execute(
            args: IssueCouponInput(profileId: testProfileId, couponId: testCouponId)
        )
        
        // Then
        #expect(result.success == false)
        #expect(result.message.contains("이미"))
    }
    
    // MARK: - 시나리오 5: 보유 쿠폰 조회
    
    @Test("유저의 보유 쿠폰 조회")
    func fetchUserCoupons() async throws {
        // Given
        let userCoupons = [
            UserCoupon(
                id: UUID(),
                profileId: testProfileId,
                couponId: testCouponId,
                issuedAt: Date(),
                usedAt: nil,
                productId: nil
            )
        ]
        
        await mockRepository.setUserCoupons(userCoupons)
        
        // When
        
        let result = try await fetchUserCouponsUseCase.execute(args: testProfileId)
        
        // Then
        #expect(result.count == 1)
        #expect(result.first?.couponId == testCouponId)
    }
}
