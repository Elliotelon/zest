//
//  AppDIContainer.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import SwiftUI

/// 앱 레벨 의존성 조립 (Repository -> UseCase -> Coordinator -> RootView)
final class AppDIContainer {
    private let client = APIService.shared
    
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
    
    private lazy var homeDIContainer: HomeDIContainer = {
        HomeDIContainer(authRepository: authRepository)
    }()
    
    private lazy var authDIContainer: AuthDIContainer = {
        AuthDIContainer(repository: authRepository)
    }()
    
    func makeRootView() -> some View {
        RootView(
            coordinator: appCoordinator,
            homeDIContainer: homeDIContainer,
            authDIContainer: authDIContainer
        )
    }
}

