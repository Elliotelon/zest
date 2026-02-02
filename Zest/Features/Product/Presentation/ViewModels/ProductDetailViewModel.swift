import SwiftUI
import Combine
import FeatureCoupon

@MainActor
final class ProductDetailViewModel: ObservableObject {
    @Published var product: Product?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCoupon: Coupon?
    @Published var appliedDiscountRate: Double = 0.0
    
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
    func applyCoupon(_ coupon: Coupon) {
        selectedCoupon = coupon
        appliedDiscountRate = coupon.discountRate
        print("🎟️ 쿠폰 적용됨: \(coupon.name) (\(coupon.discountRate)% 할인)")
    }
    
    /// 쿠폰 적용을 취소합니다.
    func removeCoupon() {
        selectedCoupon = nil
        appliedDiscountRate = 0.0
        print("🎟️ 쿠폰 적용 취소됨")
    }
    
    /// 쿠폰이 적용되었는지 확인합니다.
    var isCouponApplied: Bool {
        return selectedCoupon != nil
    }
    
    /// 쿠폰 적용 후 최종 가격을 계산합니다.
    var finalPrice: Double {
        guard let product = product else { return 0.0 }
        
        if appliedDiscountRate > 0 {
            return product.price * (1 - appliedDiscountRate / 100)
        }
        return product.price
    }
    
    /// 할인 금액을 계산합니다.
    var discountAmount: Double {
        guard let product = product else { return 0.0 }
        return product.price - finalPrice
    }
}
