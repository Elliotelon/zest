//
//  ProductDetailViewModel.swift
//  Zest
//
//  Created by AI Assistant on 1/21/26.
//

import SwiftUI
import Combine

@MainActor
final class ProductDetailViewModel: ObservableObject {
    @Published var product: Product?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isCouponApplied = false
    
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let productId: UUID
    
    init(productId: UUID, fetchProductDetailUseCase: FetchProductDetailUseCase) {
        self.productId = productId
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
    }
    
    /// 상품 상세 정보를 로드합니다.
    func loadProductDetail() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            product = try await fetchProductDetailUseCase.execute(productId: productId)
            print("✅ 상품 상세 정보 로드 성공: \(product?.name ?? "")")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 상품 상세 정보 로드 실패: \(error)")
        }
        
        isLoading = false
    }
    
    /// 쿠폰을 적용합니다.
    func applyCoupon() {
        isCouponApplied = true
        print("🎟️ 쿠폰 적용됨")
    }
    
    /// 쿠폰 적용을 취소합니다.
    func removeCoupon() {
        isCouponApplied = false
        print("🎟️ 쿠폰 적용 취소됨")
    }
    
    /// 쿠폰 적용 후 최종 가격을 계산합니다.
    var finalPrice: Double {
        guard let product = product else { return 0.0 }
        
        if isCouponApplied {
            // 임시로 10% 할인 적용
            return product.price * 0.9
        }
        return product.price
    }
    
    /// 할인 금액을 계산합니다.
    var discountAmount: Double {
        guard let product = product else { return 0.0 }
        return product.price - finalPrice
    }
}
