//
//  HomeViewModel.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fetchPostsUseCase: FetchPostsUseCase
    private let logoutUseCase: LogoutUseCase
    
    init(fetchPostsUseCase: FetchPostsUseCase,
         logoutUseCase: LogoutUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
        self.logoutUseCase = logoutUseCase
    }
    
    func load() async {
        do {
            self.posts = try await fetchPostsUseCase.execute()
            print("✅ 데이터 로드 성공: \(posts.count)개")
        } catch {
            print(String(describing: error))
        }
    }
    
    /// 로그아웃 수행
    func logout() async {
        isLoading = true
        do {
            try await logoutUseCase.execute()
            // AppCoordinator가 authStateChanges를 구독하고 있으므로
            // 여기서는 별도의 화면 전환 없이 Supabase 세션만 종료하면 됨.
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
