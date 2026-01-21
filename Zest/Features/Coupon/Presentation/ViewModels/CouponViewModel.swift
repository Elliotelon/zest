//
//  CouponViewModel.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import SwiftUI
import Combine

@MainActor
final class CouponViewModel: ObservableObject {
    @Published var availableCoupons: [Coupon] = []
    @Published var userCoupons: [UserCoupon] = []
    @Published var isLoading = false
    @Published var isIssuing = false // 쿠폰 발급 중 여부 (중복 방지)
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let fetchAvailableCouponsUseCase: FetchAvailableCouponsUseCase
    private let fetchUserCouponsUseCase: FetchUserCouponsUseCase
    let issueCouponUseCase: IssueCouponUseCase // 테스트를 위해 internal
    
    init(
        fetchAvailableCouponsUseCase: FetchAvailableCouponsUseCase,
        fetchUserCouponsUseCase: FetchUserCouponsUseCase,
        issueCouponUseCase: IssueCouponUseCase
    ) {
        self.fetchAvailableCouponsUseCase = fetchAvailableCouponsUseCase
        self.fetchUserCouponsUseCase = fetchUserCouponsUseCase
        self.issueCouponUseCase = issueCouponUseCase
    }
    
    /// 사용 가능한 쿠폰 목록을 로드합니다.
    func loadAvailableCoupons() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            availableCoupons = try await fetchAvailableCouponsUseCase.execute()
            print("✅ 쿠폰 목록 로드 성공: \(availableCoupons.count)개")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 쿠폰 목록 로드 실패: \(error)")
        }
        
        isLoading = false
    }
    
    /// 사용자가 보유한 쿠폰 목록을 로드합니다.
    func loadUserCoupons(profileId: UUID) async {
        do {
            userCoupons = try await fetchUserCouponsUseCase.execute(profileId: profileId)
            print("✅ 내 쿠폰 목록 로드 성공: \(userCoupons.count)개")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 내 쿠폰 목록 로드 실패: \(error)")
        }
    }
    
    /// 쿠폰을 발급받습니다. (동시성 제어 적용)
    /// - Parameters:
    ///   - profileId: 사용자 ID
    ///   - couponId: 쿠폰 ID
    func issueCoupon(profileId: UUID, couponId: UUID) async {
        // 중복 요청 방지
        guard !isIssuing else {
            print("⚠️ 이미 쿠폰 발급 처리 중입니다.")
            return
        }
        
        isIssuing = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let (success, message) = try await issueCouponUseCase.execute(
                profileId: profileId,
                couponId: couponId
            )
            
            if success {
                successMessage = message
                print("✅ \(message)")
                
                // 쿠폰 목록 새로고침
                await loadAvailableCoupons()
                await loadUserCoupons(profileId: profileId)
            } else {
                errorMessage = message
                print("❌ \(message)")
            }
        } catch {
            errorMessage = "쿠폰 발급 중 오류가 발생했습니다: \(error.localizedDescription)"
            print("❌ 쿠폰 발급 실패: \(error)")
        }
        
        isIssuing = false
    }
    
    /// 특정 쿠폰을 이미 보유하고 있는지 확인합니다.
    func hasUserCoupon(couponId: UUID) -> Bool {
        return userCoupons.contains { $0.couponId == couponId }
    }
}
