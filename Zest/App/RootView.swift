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
    private let homeDIContainer: HomeDIContainer
    private let authDIContainer: AuthDIContainer
    
    init(coordinator: AppCoordinator, homeDIContainer: HomeDIContainer, authDIContainer: AuthDIContainer) {
        _coordinator = StateObject(wrappedValue: coordinator)
        self.homeDIContainer = homeDIContainer
        self.authDIContainer = authDIContainer
    }
    
    var body: some View {
        Group {
            switch coordinator.currentRoute {
            case .login:
                authDIContainer.makeLoginView()
            case .home:
                homeDIContainer.makeHomeView()
            }
        }
        .task {
            await coordinator.start()
        }
    }
}

