import SwiftUI
import FeatureCoupon
import ZestCore

struct CouponListView: View {
    @StateObject var viewModel: CouponViewModel
    @ObservedObject var sessionManager = SessionManager.shared
    
    var body: some View {
        NavigationView {
            Group {
            
                if viewModel.couponScreenState.isLoading {
                    ProgressView("쿠폰 로딩 중...")
                } else if let errorMessage = viewModel.couponScreenState.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("오류 발생")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("다시 시도") {
                            Task {
                                await viewModel.loadAvailableCoupons()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if viewModel.availableCoupons.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "ticket.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("사용 가능한 쿠폰이 없습니다")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.availableCoupons) { coupon in
                            CouponCardView(
                                coupon: coupon,
                                hasIssued: viewModel.hasUserCoupon(couponId: coupon.id),
                                isIssuing: viewModel.couponScreenState.isIssuing,
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
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("쿠폰")
            .task {
                await viewModel.loadAvailableCoupons()
                if let profileId = sessionManager.profileId {
                    await viewModel.loadUserCoupons(profileId: profileId)
                }
            }
            .alert("성공", isPresented: .constant(viewModel.couponScreenState.successMessage != nil)) {
                Button("확인") {
                    viewModel.couponScreenState.successMessage = nil
                }
            } message: {
                Text(viewModel.couponScreenState.successMessage ?? "")
            }
        }
    }
}

/// 쿠폰 카드 컴포넌트
struct CouponCardView: View {
    let coupon: Coupon
    let hasIssued: Bool
    let isIssuing: Bool
    let onIssue: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 헤더
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "ticket.fill")
                            .foregroundColor(coupon.isExhausted ? .gray : .orange)
                        Text(coupon.name)
                            .font(.headline)
                            .foregroundColor(coupon.isExhausted ? .gray : .primary)
                    }
                    Text("\(Int(coupon.discountRate))% 할인")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(coupon.isExhausted ? .gray : .orange)
                }
                
                Spacer()
                
                // 발급 버튼
                if !hasIssued && !coupon.isExhausted {
                    Button(action: onIssue) {
                        if isIssuing {
                            ProgressView()
                                .controlSize(.small)
                                .tint(.white)
                        } else {
                            Text("발급받기")
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.orange)
                    .cornerRadius(20)
                    .disabled(isIssuing)
                } else if hasIssued {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("보유중")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.green)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(20)
                }
            }
            
            Divider()
            
            // 수량 정보
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("발급 현황:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if coupon.isExhausted {
                    Text("소진됨")
                        .font(.caption)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(4)
                } else {
                    HStack(spacing: 4) {
//                        Button("강제 크래시") {
//                            fatalError("쿠폰강제 크래시")
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .tint(.red)
                        Text("\(coupon.issuedCount)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(coupon.remainingCount < 10 ? .red : .orange)
                        Text("/ \(coupon.maxCount)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("(\(coupon.remainingCount)개 남음)")
                            .font(.caption2)
                            .foregroundColor(coupon.remainingCount < 10 ? .red : .secondary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(coupon.isExhausted ? Color.gray.opacity(0.1) : Color.orange.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    coupon.isExhausted ? Color.gray.opacity(0.3) : Color.orange.opacity(0.3),
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    let logger = MockLogger()
    let couponDIContainer = CouponDIContainer(logger: logger)
    couponDIContainer.makeCouponListView()
}


