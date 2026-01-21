//
//  CouponDIContainer.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Supabase
import SwiftUI

final class CouponDIContainer {
    private let client = APIService.shared
    
    func makeCouponViewModel() -> CouponViewModel {
        let repository = CouponRepository(client: client)
        let fetchAvailableCouponsUseCase = FetchAvailableCouponsUseCase(repository: repository)
        let fetchUserCouponsUseCase = FetchUserCouponsUseCase(repository: repository)
        let issueCouponUseCase = IssueCouponUseCase(repository: repository)
        
        return CouponViewModel(
            fetchAvailableCouponsUseCase: fetchAvailableCouponsUseCase,
            fetchUserCouponsUseCase: fetchUserCouponsUseCase,
            issueCouponUseCase: issueCouponUseCase
        )
    }
    
    func makeCouponListView() -> some View {
        let viewModel = makeCouponViewModel()
        return CouponListView(viewModel: viewModel)
    }
}
