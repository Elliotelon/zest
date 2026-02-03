import SwiftUI
import ZestCore
import FeatureCoupon

struct ProductDetailView: View {
    @StateObject var viewModel: ProductDetailViewModel
    @StateObject var couponViewModel: CouponViewModel
    let profileId: UUID?
    
    var body: some View {
        ScrollView {
            // MARK: - 상품 로딩 / 에러 / 콘텐츠 분기
            if viewModel.isLoading {
                ProgressView("상품 정보 로딩 중...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage) {
                    Task { await viewModel.loadProductDetail() }
                }
            } else if let product = viewModel.product {
                productContent(product: product)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadProductDetail()
            
            if let profileId = profileId {
                await couponViewModel.loadAvailableCoupons()
                await couponViewModel.loadUserCoupons(profileId: profileId)
            }
        }
    }
    
    // MARK: - 상품 콘텐츠
    @ViewBuilder
    private func productContent(product: Product) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                Text(product.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                priceView(product: product)
                
                Divider()
                
                productDescriptionView(product: product)
                
                Divider()
                
                couponSectionView()
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - 가격 정보
    @ViewBuilder
    private func priceView(product: Product) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.isCouponApplied {
                HStack {
                    Text("원가")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("₩\(Int(product.price))")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .strikethrough()
                }
                
                HStack {
                    Text("할인가")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("₩\(Int(viewModel.finalPrice))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                
                Text("-₩\(Int(viewModel.discountAmount)) 할인")
                    .font(.caption)
                    .foregroundColor(.red)
            } else {
                Text("₩\(Int(product.price))")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - 상품 설명
    @ViewBuilder
    private func productDescriptionView(product: Product) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("상품 설명")
                .font(.headline)
            Text(product.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - 쿠폰 섹션
    @ViewBuilder
    private func couponSectionView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("쿠폰")
                .font(.headline)
            
            switch couponViewModel.state {
            case .idle, .loading:
                ProgressView("쿠폰 로딩 중...")
                    .frame(maxWidth: .infinity)
                    .padding()
                
            case .empty:
                Text("현재 사용 가능한 쿠폰이 없습니다.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                
            case let .content(availableCoupons, userCoupons):
                ForEach(availableCoupons) { coupon in
                    ProductDetailCouponCardView(
                        coupon: coupon,
                        isApplied: viewModel.selectedCoupon?.id == coupon.id,
                        hasIssued: couponViewModel.hasUserCoupon(couponId: coupon.id, in: userCoupons),
                        isIssuing: couponViewModel.isIssuing,
                        onIssue: {
                            guard let profileId = profileId else { return }
                            Task {
                                await couponViewModel.issueCoupon(profileId: profileId, couponId: coupon.id)
                            }
                        },
                        onApply: {
                            if viewModel.selectedCoupon?.id == coupon.id {
                                viewModel.removeCoupon()
                            } else {
                                viewModel.applyCoupon(coupon)
                            }
                        }
                    )
                }
                
            case let .error(errorState):
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage(for: errorState))
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding()
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - 쿠폰 에러 메시지
    private func errorMessage(for errorState: CouponErrorState) -> String {
        switch errorState {
        case .network:
            return "네트워크 오류가 발생했습니다."
        case .server:
            return "서버 오류가 발생했습니다."
        case .unauthorized:
            return "로그인이 필요합니다."
        case let .domain(message):
            return message
        }
    }
    
    // MARK: - 에러 뷰
    @ViewBuilder
    private func errorView(message: String, retryAction: @escaping () -> Void) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text("오류 발생")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Button("다시 시도", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}

/// 쿠폰 카드 컴포넌트
struct ProductDetailCouponCardView: View {
    let coupon: Coupon
    let isApplied: Bool
    let hasIssued: Bool
    let isIssuing: Bool
    let onIssue: () -> Void
    let onApply: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "ticket.fill")
                        .foregroundColor(coupon.isExhausted ? .gray : .orange)
                    Text(coupon.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(coupon.isExhausted ? .gray : .primary)
                }
                Text("\(Int(coupon.discountRate))% 할인")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    if coupon.isExhausted {
                        Text("소진됨")
                            .font(.caption2)
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    } else {
                        Text("남은 수량:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(coupon.remainingCount)/\(coupon.maxCount)")
                            .font(.caption2)
                            .foregroundColor(coupon.remainingCount < 10 ? .red : .orange)
                            .fontWeight(.semibold)
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                if !hasIssued && !coupon.isExhausted {
                    Button(action: onIssue) {
                        if isIssuing {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Text("발급")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 60)
                    .padding(.vertical, 6)
                    .background(Color.orange)
                    .cornerRadius(8)
                    .disabled(isIssuing)
                }
                
                if hasIssued {
                    Button(action: onApply) {
                        Text(isApplied ? "적용됨" : "적용")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: 60)
                    .padding(.vertical, 6)
                    .background(isApplied ? Color.green : Color.blue)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(coupon.isExhausted ? Color.gray.opacity(0.1) : Color.orange.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isApplied ? Color.green : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    let logger = MockLogger()
    let productRepository = ProductRepository(client: APIService.shared.client)
    let productUseCase = FetchProductDetailUseCase(repository: productRepository)
    let productViewModel = ProductDetailViewModel(
        productId: UUID(),
        fetchProductDetailUseCase: productUseCase
    )
    
    let couponDIContainer = CouponDIContainer(logger: logger)
    let couponViewModel = couponDIContainer.makeCouponViewModel()
    
    NavigationView {
        ProductDetailView(
            viewModel: productViewModel,
            couponViewModel: couponViewModel,
            profileId: UUID()
        )
    }
}
