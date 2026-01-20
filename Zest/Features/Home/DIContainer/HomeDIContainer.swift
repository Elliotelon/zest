//
//  HomeDIContainer.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import SwiftUI

final class HomeDIContainer {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func makeHomeView() -> some View {
        let fetchPostsUsecase = FetchPostsUseCase(repository: PostRepository())
        let logoutUseCase = LogoutUseCase(repository: authRepository)
        let viewModel = HomeViewModel(
            fetchPostsUseCase: fetchPostsUsecase,
            logoutUseCase: logoutUseCase
        )
        return HomeView(viewModel: viewModel)
    }
}