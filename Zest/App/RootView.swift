//
//  RootView.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import SwiftUI

/// AppCoordinator의 currentRoute에 따라 로그인/홈 화면을 분기하는 루트 뷰
struct RootView: View {
   @StateObject private var coordinator: AppCoordinator
    private let authDIContainer: AuthDIContainer
    private let productDIContainer: ProductDIContainer
    private let cartDIContainer: CartDIContainer
    private let authRepository: AuthRepositoryProtocol
    
    init(
        coordinator: AppCoordinator,
        authDIContainer: AuthDIContainer,
        productDIContainer: ProductDIContainer,
        cartDIContainer: CartDIContainer,
        authRepository: AuthRepositoryProtocol
    ) {
        _coordinator = StateObject(wrappedValue: coordinator)
        self.authDIContainer = authDIContainer
        self.productDIContainer = productDIContainer
        self.cartDIContainer = cartDIContainer
        self.authRepository = authRepository
    }
    
    var body: some View {
        Group {
            switch coordinator.currentRoute {
            case .login:
                authDIContainer.makeLoginView()
            case .home:
                MainTabView(
                    productDIContainer: productDIContainer,
                    cartDIContainer: cartDIContainer,
                    profileId: UUID(), // TODO: 실제 사용자 ID 가져오기
                    email: nil, // TODO: 실제 이메일 가져오기
                    name: nil, // TODO: 실제 이름 가져오기
                    onLogout: {
                        Task {
                            try? await authRepository.signOut()
                        }
                    }
                )
            }
        }
        .task {
            await coordinator.start()
        }
    }
}

