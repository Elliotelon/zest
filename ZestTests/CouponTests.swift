//
//  CouponTests.swift
//  ZestTests
//
//  Created by AI Assistant on 1/22/26.
//

import XCTest
@testable import Zest

@MainActor
final class CouponTests: XCTestCase {
    
    var sut: CouponViewModel!
    var mockRepository: MockCouponRepository!
    
    let testCouponId = UUID()
    let testProfileId = UUID()
    
    override func setUp() async throws {
        mockRepository = MockCouponRepository()
        
        let fetchAvailableCouponsUseCase = FetchAvailableCouponsUseCase(repository: mockRepository)
        let fetchUserCouponsUseCase = FetchUserCouponsUseCase(repository: mockRepository)
        let issueCouponUseCase = IssueCouponUseCase(repository: mockRepository)
        
        sut = CouponViewModel(
            fetchAvailableCouponsUseCase: fetchAvailableCouponsUseCase,
            fetchUserCouponsUseCase: fetchUserCouponsUseCase,
            issueCouponUseCase: issueCouponUseCase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
    }
    
    // MARK: - 시나리오 1: 기본 쿠폰 조회
    
    func test1_FetchAvailableCoupons_Success() async throws {
        // Given
        let expectedCoupons = [
            Coupon(id: UUID(), name: "테스트 쿠폰 1", discountRate: 10.0, maxCount: 100, issuedCount: 50, isActive: true, createdAt: Date()),
            Coupon(id: UUID(), name: "테스트 쿠폰 2", discountRate: 20.0, maxCount: 50, issuedCount: 10, isActive: true, createdAt: Date())
        ]
        await mockRepository.setAvailableCoupons(expectedCoupons)
        
        // When
        await sut.loadAvailableCoupons()
        
        // Then
        XCTAssertEqual(sut.availableCoupons.count, 2, "쿠폰 목록이 정상 조회되어야 합니다")
        XCTAssertEqual(sut.availableCoupons[0].name, "테스트 쿠폰 1")
        XCTAssertEqual(sut.availableCoupons[0].discountRate, 10.0)
        XCTAssertEqual(sut.availableCoupons[0].issuedCount, 50)
        XCTAssertNil(sut.errorMessage, "에러 메시지가 없어야 합니다")
        
        print("✅ 시나리오 1 통과: 쿠폰 목록 조회 성공")
    }
    
    // MARK: - 시나리오 2: 쿠폰 발급 성공
    
    func test2_IssueCoupon_Success() async throws {
        // Given
        await mockRepository.setMaxCouponCount(100)
        await mockRepository.setCurrentIssuedCount(50)
        
        // When
        await sut.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        let currentIssuedCount = await mockRepository.currentIssuedCount
        let issuedProfileIds = await mockRepository.issuedProfileIds
        
        // Then
        XCTAssertNotNil(sut.successMessage, "성공 메시지가 있어야 합니다")
        XCTAssertNil(sut.errorMessage, "에러 메시지가 없어야 합니다")
        XCTAssertEqual(currentIssuedCount, 51, "발급 수량이 증가해야 합니다")
        XCTAssertTrue(issuedProfileIds.contains(testProfileId), "발급 내역에 추가되어야 합니다")
        
        print("✅ 시나리오 2 통과: 쿠폰 발급 성공")
    }
    
    // MARK: - 시나리오 3: 동시성 요청
    
    func test3_ConcurrentRequests_OnlyMaxCountSucceed() async throws {
        // Given
        let numberOfRequests = 10
        let profileIds = (0..<numberOfRequests).map { _ in UUID() }
        await mockRepository.setMaxCouponCount(5) // 최대 5개만 발급 가능
        await mockRepository.setCurrentIssuedCount(0)
        
        var results: [(Bool, String)] = []
        
        // When: 10명이 동시에 요청
        await withTaskGroup(of: (Bool, String).self) { group in
            for profileId in profileIds {
                group.addTask {
                    do {
                        return try await self.mockRepository.issueCoupon(
                            profileId: profileId,
                            couponId: self.testCouponId
                        )
                    } catch {
                        return (false, error.localizedDescription)
                    }
                }
            }
            
            for await result in group {
                results.append(result)
            }
        }
        
        // Then
        let successCount = results.filter { $0.0 }.count
        let failureCount = results.filter { !$0.0 }.count
        let currentIssuedCount = await mockRepository.currentIssuedCount
        
        XCTAssertEqual(successCount, 5, "정확히 5명만 성공해야 합니다")
        XCTAssertEqual(failureCount, 5, "나머지 5명은 실패해야 합니다")
        XCTAssertEqual(currentIssuedCount, 5, "최종 발급 수량이 정확해야 합니다")
        
        // 실패 메시지 검증
        let failedMessages = results.filter { !$0.0 }.map { $0.1 }
        for message in failedMessages {
            XCTAssertTrue(message.contains("소진"), "쿠폰 소진 메시지여야 합니다")
        }
        
        print("✅ 시나리오 3 통과: 동시성 제어 정상 작동 (5/10 성공)")
    }
    
    // MARK: - 시나리오 4: 이미 발급받은 쿠폰
    
    func test4_IssueCoupon_AlreadyIssued() async throws {
        // Given
        await mockRepository.setMaxCouponCount(10)
        await mockRepository.setIssuedProfileIds(testProfileId) // 이미 발급받음
        
        // When
        await sut.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        XCTAssertNotNil(sut.errorMessage, "에러 메시지가 있어야 합니다")
        XCTAssertNil(sut.successMessage, "성공 메시지가 없어야 합니다")
        XCTAssertTrue(
            sut.errorMessage?.contains("이미") ?? false,
            "이미 발급받았다는 메시지여야 합니다"
        )
        
        print("✅ 시나리오 4 통과: 중복 발급 차단")
    }
    
    // MARK: - 시나리오 5: 쿠폰 소진
    
    func test5_IssueCoupon_Exhausted() async throws {
        // Given
        await mockRepository.setMaxCouponCount(100)
        await mockRepository.setCurrentIssuedCount(100) // 이미 100개 모두 발급됨
        
        // When
        await sut.issueCoupon(profileId: testProfileId, couponId: testCouponId)
        
        // Then
        XCTAssertNotNil(sut.errorMessage, "에러 메시지가 있어야 합니다")
        XCTAssertNil(sut.successMessage, "성공 메시지가 없어야 합니다")
        XCTAssertTrue(
            sut.errorMessage?.contains("소진") ?? false,
            "쿠폰 소진 메시지여야 합니다"
        )
        let currentIssuedCount = await mockRepository.currentIssuedCount
        XCTAssertEqual(currentIssuedCount, 100, "발급 수량이 증가하지 않아야 합니다")
        
        print("✅ 시나리오 5 통과: 쿠폰 소진 시 발급 차단")
    }
    
    // MARK: - 시나리오 6: UI/UX 검증 (ViewModel 레벨)
    
//    func test6_ViewModel_LoadingStates() async throws {
//        // Given
//        await mockRepository.setDelaySeconds(0.5)// 로딩 시뮬레이션
//        
//        // When: 로딩 시작
//        let loadTask = Task {
//            await sut.loadAvailableCoupons()
//        }
//        
//        // 짧은 대기 후 로딩 상태 확인
//        try await Task.sleep(for: .seconds(0.1)) // 0.1초
//        
//        // Then: 로딩 중
//        XCTAssertTrue(sut.isLoading, "로딩 중이어야 합니다")
//        
//        // 완료 대기
//        await loadTask.value
//        
//        // Then: 로딩 완료
//        XCTAssertFalse(sut.isLoading, "로딩이 완료되어야 합니다")
//        
//        print("✅ 시나리오 6 통과: 로딩 상태 관리 정상")
//    }
    
    func test6_HasUserCoupon_ReturnsCorrectStatus() async {
        // Given
        let couponId1 = UUID()
        let couponId2 = UUID()
        
        sut.userCoupons = [
            UserCoupon(id: UUID(), profileId: testProfileId, couponId: couponId1, issuedAt: Date(), usedAt: nil, productId: nil)
        ]
        
        // When & Then
        XCTAssertTrue(sut.hasUserCoupon(couponId: couponId1), "보유한 쿠폰은 true여야 합니다")
        XCTAssertFalse(sut.hasUserCoupon(couponId: couponId2), "보유하지 않은 쿠폰은 false여야 합니다")
        
        print("✅ 시나리오 6 통과: 쿠폰 보유 여부 확인 정상")
    }
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
