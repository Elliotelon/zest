import Supabase
import SwiftUI
import ZestCore
<<<<<<<< HEAD:Zest/Features/Coupon/DIContainer/CouponDIContainer.swift
import FeatureCoupon
========
>>>>>>>> d9efb0e6e9c4b0730695120d8bc3151909806423:FeatureCoupon/Sources/FeatureCoupon/DIContainer/CouponDIContainer.swift

@MainActor
final class CouponDIContainer {
    private var client: SupabaseClient {
        APIService.shared.client
    }
    
    private let logger: any Logger
    
    init(logger: any Logger) {
        self.logger = logger
    }
<<<<<<<< HEAD:Zest/Features/Coupon/DIContainer/CouponDIContainer.swift

    func makeCouponViewModel() -> CouponViewModel {
========
    
    public func makeCouponViewModel() -> CouponViewModel {
>>>>>>>> d9efb0e6e9c4b0730695120d8bc3151909806423:FeatureCoupon/Sources/FeatureCoupon/DIContainer/CouponDIContainer.swift
        let repository = CouponRepository(client: client)
        
        let fetchAvailableCouponsUseCase = FetchAvailableCouponsUseCase(repository: repository)
        let fetchUserCouponsUseCase = FetchUserCouponsUseCase(repository: repository)
        let issueCouponUseCase = IssueCouponUseCase(repository: repository)
        
        // LoggingUseCase로 감싸기
        let loggingFetchAvailableCouponsUseCase = LoggingFetchAvailableCouponsUseCase(
            decorated: fetchAvailableCouponsUseCase,
            logger: logger,
            screen: "CouponScreen"
        )
        
        return CouponViewModel(
            fetchAvailableCouponsUseCase: loggingFetchAvailableCouponsUseCase,
            fetchUserCouponsUseCase: fetchUserCouponsUseCase,
            issueCouponUseCase: issueCouponUseCase
        )
    }
    
    @MainActor
<<<<<<<< HEAD:Zest/Features/Coupon/DIContainer/CouponDIContainer.swift
    func makeCouponListView() -> some View {
        let viewModel = self.makeCouponViewModel()
        return CouponListView(viewModel: viewModel) // 이제 앱 타겟이므로 CouponListView를 인식함
    }
========
    public func makeCouponListView() -> some View {
        let viewModel = self.makeCouponViewModel()
        return CouponListView(viewModel: viewModel)
    }
    
    
>>>>>>>> d9efb0e6e9c4b0730695120d8bc3151909806423:FeatureCoupon/Sources/FeatureCoupon/DIContainer/CouponDIContainer.swift
}
