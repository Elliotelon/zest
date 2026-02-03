import SwiftUI
import ZestCore

struct CouponListView: View {
    @StateObject var viewModel: CouponViewModel
    @ObservedObject var sessionManager = SessionManager.shared

    var body: some View {
        NavigationView {
            content
                .navigationTitle("쿠폰")
                .onChange(of: sessionManager.profileId) { newId in
                    guard let id = newId else { return }
                    Task {
                        await viewModel.loadAvailableCoupons()
                        await viewModel.loadUserCoupons(profileId: id)
                    }
                }
                .toast(message: $viewModel.toastMessage)
        }
        .task {
            if let profileId = sessionManager.profileId {
                await viewModel.loadAvailableCoupons()
                await viewModel.loadUserCoupons(profileId: profileId)
            }
        }
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {

        case .idle:
            EmptyView()

        case .loading:
            ProgressView("쿠폰 로딩 중...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            VStack(spacing: 16) {
                Image(systemName: "ticket.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                Text("사용 가능한 쿠폰이 없습니다")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

        case .error(let error):
            errorView(error)

        case .content(let availableCoupons, let userCoupons):
            List {
                ForEach(availableCoupons) { coupon in
                    CouponCardView(
                        coupon: coupon,
                        hasIssued: viewModel.hasUserCoupon(
                            couponId: coupon.id,
                            in: userCoupons
                        ),
                        isIssuing: viewModel.isIssuing,
                        onIssue: {
                            guard let profileId = sessionManager.profileId else {
                                print("⚠️ 로그인이 필요합니다")
                                return
                            }
                            Task {
                                await viewModel.issueCoupon(
                                    profileId: profileId,
                                    couponId: coupon.id
                                )
                            }
                        }
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(
                        EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                    )
                }
            }
            .listStyle(.plain)
        }
    }

    // MARK: - Error View
    @ViewBuilder
    private func errorView(_ error: CouponErrorState) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            Text(errorTitle(error))
                .font(.headline)

            Text(errorMessage(error))
                .font(.caption)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)

            Button("다시 시도") {
                if let profileId = sessionManager.profileId {
                    Task {
                        await viewModel.loadAvailableCoupons()
                        await viewModel.loadUserCoupons(profileId: profileId)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // MARK: - Error Helpers
    private func errorTitle(_ error: CouponErrorState) -> String {
        switch error {
        case .network:
            return "네트워크 오류"
        case .unauthorized:
            return "로그인이 필요합니다"
        case .server, .domain:
            return "오류 발생"
        }
    }

    private func errorMessage(_ error: CouponErrorState) -> String {
        switch error {
        case .network:
            return "인터넷 연결을 확인해주세요."
        case .unauthorized:
            return "다시 로그인 후 이용해주세요."
        case .server:
            return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .domain(let message):
            return message
        }
    }
}

//#Preview {
//    // 1️⃣ Mock Logger & DI Container
//    let logger = MockLogger()
//    let couponDIContainer = CouponDIContainer(logger: logger)
//    
//    // 2️⃣ Mock ViewModel 생성
//    let viewModel = couponDIContainer.makeCouponViewModel()
//    
//    // 3️⃣ 샘플 쿠폰 & 유저 쿠폰 설정
//    let sampleCoupon = Coupon(
//        id: UUID(),
//        name: "10% 할인",
//        discountRate: 10,
//        maxCount: 100,
//        issuedCount: 0,
//        isActive: true,
//        createdAt: Date()
//    )
//    let sampleUserCoupon = UserCoupon(
//        id: UUID(),
//        profileId: UUID(),
//        couponId: sampleCoupon.id,
//        issuedAt: Date(),
//        usedAt: nil,
//        productId: nil
//    )
//    
//    // state를 content로 강제 설정
//    viewModel.state = .content(
//        availableCoupons: [sampleCoupon],
//        userCoupons: [sampleUserCoupon]
//    )
//    
//    // 4️⃣ Mock SessionManager (로그인 상태)
//    let mockSessionManager = MockSessionManager()
//    mockSessionManager.profileId = UUID() // 로그인된 상태
//    
//    // 5️⃣ CouponListView 생성
//    CouponListView(
//        viewModel: viewModel,
//        sessionManager: mockSessionManager
//    )
//}

