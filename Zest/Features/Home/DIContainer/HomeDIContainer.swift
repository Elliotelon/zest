//
//  HomeDIContainer.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Supabase
import SwiftUI

final class HomeDIContainer {
    private let client = SupabaseClient(
        supabaseURL: Env.supabaseURL,
        supabaseKey: Env.supabaseAnonKey
    )

    func makeHomeView() -> some View {
        let appleLoginUseCase = AppleLoginUseCase(repository: AuthRepository(client: client))
        let fetchPostsUsecase = FetchPostsUseCase(repository: PostRepository())
        let viewModel = HomeViewModel(fetchPostsUseCase: fetchPostsUsecase, appleLoginUseCase: appleLoginUseCase)
        return HomeView(viewModel: viewModel)
    }
}
