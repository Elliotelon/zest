import SwiftUI
import ZestCore

extension CouponDIContainer {
    @MainActor
    public func makeCouponListView() -> some View {
        let viewModel = self.makeCouponViewModel()
        return CouponListView(viewModel: viewModel) // 이제 앱 타겟이므로 CouponListView를 인식함
    }
}
