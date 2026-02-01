import Testing
import Foundation
@testable import ZestCore

@Suite("쿠폰 비즈니스 로직 테스트")
@MainActor
struct CouponTests {
    
    // Properties (SUT 및 Mock)
    private var sut: CouponViewModel
    private var mockRepository: MockCouponRepository
    private let testCouponId = UUID()
    private let testProfileId = UUID()
    
    // Swift Testing에서는 init이 XCTest의 setUp 역할
    init() async throws {
        let repository = MockCouponRepository()
        self.mockRepository = repository
        
        let fetchAvailableCouponsUseCase = FetchAvailableCouponsUseCase(repository: repository)
        let fetchUserCouponsUseCase = FetchUserCouponsUseCase(repository: repository)
        let issueCouponUseCase = IssueCouponUseCase(repository: repository)
        
        self.sut = CouponViewModel(
            fetchAvailableCouponsUseCase: fetchAvailableCouponsUseCase,
            fetchUserCouponsUseCase: fetchUserCouponsUseCase,
            issueCouponUseCase: issueCouponUseCase
        )
    }
    
    // MARK: - 시나리오 1: 기본 쿠폰 조회
    
    @Test("사용 가능한 쿠폰 목록 조회 성공")
    func fetchAvailableCouponsSuccess() async throws {
        // Given
        let expectedCoupons = [
            Coupon(id: UUID(), name: "테스트 쿠폰 1", discountRate: 10.0, maxCount: 100, issuedCount: 50, isActive: true, createdAt: Date()),
            Coupon(id: UUID(), name: "테스트 쿠폰 2", discountRate: 20.0, maxCount: 50, issuedCount: 10, isActive: true, createdAt: Date())
        ]
        await mockRepository.setAvailableCoupons(expectedCoupons)
        
        // When
        await sut.loadAvailableCoupons()
        
        // Then
        #expect(sut.availableCoupons.count == 2)
        #expect(sut.availableCoupons[0].name == "테스트 쿠폰 1")
        #expect(sut.availableCoupons[0].discountRate == 10.0)
        #expect(sut.couponScreenState.errorMessage == nil)
    }
    
    // MARK: - 시나리오 2: 쿠폰 발급 성공
    
    @Test("쿠폰 발급 프로세스 성공 확인")
    func issueCouponSuccess() async throws {
        // Given
        await mockRepository.setMaxCouponCount(100)
        await mockRepository.setCurrentIssuedCount(50)
        
        // When
        await sut.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        let currentCount = await mockRepository.currentIssuedCount
        let issuedIds = await mockRepository.issuedProfileIds
        
        // Then
        #expect(sut.couponScreenState.successMessage != nil)
        #expect(sut.couponScreenState.errorMessage == nil)
        #expect(currentCount == 51)
        #expect(issuedIds.contains(testProfileId))
    }
    
//    // MARK: - 시나리오 3: 중복 요청 방지
//
//    @Test("쿠폰 발급 중 중복 요청은 한 번만 처리된다")
//    func issueCouponDeduplicatesWhileLoading() async throws {
//        // Given
//        await mockRepository.setDelaySeconds(0.3)
//
//        // When: 거의 동시에 두 번 요청 (버튼 연타 상황)
//        async let firstRequest = sut.issueCoupon(
//            profileId: testProfileId,
//            couponId: testCouponId
//        )
//
//        async let secondRequest = sut.issueCoupon(
//            profileId: testProfileId,
//            couponId: testCouponId
//        )
//
//        _ = await (firstRequest, secondRequest)
//
//        // Then: 실제 발급 요청은 한 번만 발생
//        let callCount = await mockRepository.issueCouponCallCount
//        #expect(callCount == 1)
//
//        #expect(sut.isLoading == false)
//        #expect(sut.errorMessage == nil)
//    }

    
//    // MARK: - 시나리오 3: 동시성 요청 (TaskGroup 활용)
//    
//    @Test("동시성 제어: 최대 수량 초과 발급 제한 확인")
//    func concurrentRequestsOnlyMaxCountSucceed() async throws {
//        // Given
//        let numberOfRequests = 10
//        let profileIds = (0..<numberOfRequests).map { _ in UUID() }
//        await mockRepository.setMaxCouponCount(5) // 최대 5개
//        await mockRepository.setCurrentIssuedCount(0)
//        
//        // When: 10명이 동시에 요청
//        let results = await withTaskGroup(of: (Bool, String).self) { group in
//            for profileId in profileIds {
//                group.addTask {
//                    do {
//                        return try await self.mockRepository.issueCoupon(
//                            profileId: profileId,
//                            couponId: self.testCouponId
//                        )
//                    } catch {
//                        return (false, error.localizedDescription)
//                    }
//                }
//            }
//            
//            var collectedResults: [(Bool, String)] = []
//            for await result in group {
//                collectedResults.append(result)
//            }
//            return collectedResults
//        }
//        
//        // Then
//        let successCount = results.filter { $0.0 }.count
//        let currentCount = await mockRepository.currentIssuedCount
//        
//        #expect(successCount == 5)
//        #expect(currentCount == 5)
//        
//        let failedMessages = results.filter { !$0.0 }.map { $0.1 }
//        for message in failedMessages {
//            #expect(message.contains("소진"))
//        }
//    }
    
    // MARK: - 시나리오 4: 중복 발급 차단
    
    @Test("이미 발급받은 유저의 재발급 차단")
    func issueCouponAlreadyIssued() async throws {
        // Given
        await mockRepository.setMaxCouponCount(10)
        await mockRepository.setIssuedProfileIds(testProfileId)
        
        // When
        await sut.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        #expect(sut.couponScreenState.errorMessage != nil)
        #expect(sut.couponScreenState.errorMessage?.contains("이미") == true)
        #expect(sut.couponScreenState.successMessage == nil)
    }
    
    // MARK: - 시나리오 5: UI 상태 관리 (ViewModel 로딩)
    
    @Test("데이터 로딩 시 isLoading 상태 변화 확인")
    func viewModelLoadingStates() async throws {
        // Given
        await mockRepository.setDelaySeconds(0.3)
        
        // When
        let loadTask = Task { await sut.loadAvailableCoupons() }
        
        // 조금 대기 후 로딩 중인지 확인
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.couponScreenState.isLoading == true)
        
        await loadTask.value
        
        // Then
        #expect(sut.couponScreenState.isLoading == false)
    }
    
    @Test("보유한 쿠폰 여부 판단 로직 확인")
    func hasUserCouponReturnsCorrectStatus() async {
        // Given
        let couponId1 = UUID()
        let couponId2 = UUID()
        sut.userCoupons = [
            UserCoupon(id: UUID(), profileId: testProfileId, couponId: couponId1, issuedAt: Date(), usedAt: nil, productId: nil)
        ]
        
        // When & Then
        #expect(sut.hasUserCoupon(couponId: couponId1) == true)
        #expect(sut.hasUserCoupon(couponId: couponId2) == false)
    }
    
    
    // MARK: - Mock Repository
    
    actor MockCouponRepository: CouponRepositoryProtocol {
        private(set) var availableCoupons: [Coupon] = []
        private(set) var issueCouponCallCount = 0
        private(set) var maxCouponCount = 100
        private(set) var currentIssuedCount = 0
        private(set) var issuedProfileIds: Set<UUID> = []
        private(set) var delaySeconds: Double = 0.0
        
        func setAvailableCoupons(_ coupon: [Coupon]) {
            self.availableCoupons = coupon
        }
        func setIssueCouponCallCount(_ count: Int) {
            self.issueCouponCallCount = count
        }
        func setMaxCouponCount(_ count: Int) {
            self.maxCouponCount = count
        }
        func setCurrentIssuedCount(_ count: Int) {
            self.currentIssuedCount = count
        }
        func setIssuedProfileIds(_ profileId: UUID) {
            self.issuedProfileIds.insert(profileId)
        }
        func setDelaySeconds(_ seconds: Double) {
            self.delaySeconds = seconds
        }
        
        func fetchAvailableCoupons() async throws -> [Coupon] {
            if delaySeconds > 0 {
                try await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
            }
            return availableCoupons
        }
        
        func fetchCoupon(id: UUID) async throws -> Coupon {
            return Coupon(
                id: id,
                name: "테스트 쿠폰",
                discountRate: 10.0,
                maxCount: maxCouponCount,
                issuedCount: currentIssuedCount,
                isActive: true,
                createdAt: Date()
            )
        }
        
        func issueCoupon(profileId: UUID, couponId: UUID) async throws -> (success: Bool, message: String) {
            // 응답 지연 시뮬레이션
            if delaySeconds > 0 {
                try await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
            }
            
            issueCouponCallCount += 1
            
            // 이미 발급받은 쿠폰인지 확인
            if issuedProfileIds.contains(profileId) {
                return (false, "이미 발급받은 쿠폰입니다.")
            }
            
            // 쿠폰 수량 확인
            if currentIssuedCount >= maxCouponCount {
                return (false, "쿠폰이 모두 소진되었습니다.")
            }
            
            // 쿠폰 발급
            currentIssuedCount += 1
            issuedProfileIds.insert(profileId)
            
            return (true, "쿠폰 발급 성공! (\(currentIssuedCount)/\(maxCouponCount))")
        }
        
        func fetchUserCoupons(profileId: UUID) async throws -> [UserCoupon] {
            return []
        }
        
        func useCoupon(userCouponId: UUID, productId: UUID) async throws {
            // Mock implementation
        }
    }
}

