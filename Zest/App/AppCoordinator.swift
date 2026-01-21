//
//  AppCoordinator.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import SwiftUI
import Combine

/// 앱 시작 시 세션을 확인하고, 이후 Auth 상태 변화를 감지해 화면을 전환하는 코디네이터
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    @Published var userId: UUID?
    
    private let checkSessionUseCase: CheckSessionUseCase
    private let authRepository: AuthRepositoryProtocol
    private var authStateTask: Task<Void, Never>?
    private var isInitialized = false
    
    init(checkSessionUseCase: CheckSessionUseCase,
         authRepository: AuthRepositoryProtocol) {
        self.checkSessionUseCase = checkSessionUseCase
        self.authRepository = authRepository
    }
    
    /// 앱 시작 시 한 번 호출
    func start() async {
        await checkInitialSession()
        observeAuthChanges()
    }
    
    private func checkInitialSession() async {
        guard !isInitialized else { return }
        let hasSession = await checkSessionUseCase.execute()
         
        currentRoute = hasSession ? .home : .login
        self.isInitialized = true
    }
    
    private func observeAuthChanges() {
        authStateTask = authRepository.observeAuthStateChanges { [weak self] isAuthenticated in
            guard let self else { return }
            self.currentRoute = isAuthenticated ? .home : .login
        }
    }
    
    deinit {
        authStateTask?.cancel()
    }
}

