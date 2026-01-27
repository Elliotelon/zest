//
//  CouponDIContainer.swift
//  Zest
//
//  Created by AI Assistant on 1/22/26.
//

import Supabase
import SwiftUI

@MainActor
public final class CouponDIContainer {
    private var client: SupabaseClient {
        APIService.shared.client
    }
    
    public init() {}
    
    public func makeCouponViewModel() -> CouponViewModel {
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
}
