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
    
    private let logger: any Logger
    
    public init(logger: any Logger) {
        self.logger = logger
    }
    
    
   
    

    public func makeCouponViewModel() -> CouponViewModel {
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
}
