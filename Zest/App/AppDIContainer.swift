//
//  AppDIContainer.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import SwiftUI
import ZestCore

/// 앱 레벨 의존성 조립 (Repository -> UseCase -> Coordinator -> RootView)
@MainActor
final class AppDIContainer {
    private let client = APIService.shared.client
    
    private lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository(client: client)
    }()
    
    private lazy var checkSessionUseCase: CheckSessionUseCase = {
        CheckSessionUseCase(repository: authRepository)
    }()
    
    private lazy var appCoordinator: AppCoordinator = {
        AppCoordinator(
            checkSessionUseCase: checkSessionUseCase,
            authRepository: authRepository
        )
    }()
    
    private lazy var authDIContainer: AuthDIContainer = {
        AuthDIContainer(repository: authRepository)
    }()
    
    private lazy var productDIContainer: ProductDIContainer = {
        ProductDIContainer()
    }()
    
    private lazy var couponDIContainer: CouponDIContainer = {
        CouponDIContainer()
    }()
    
    func makeRootView() -> some View {
        RootView(
            coordinator: appCoordinator,
            authDIContainer: authDIContainer,
            productDIContainer: productDIContainer,
            couponDIContainer: couponDIContainer,
            authRepository: authRepository
        )
    }
}

