//
//  HomeViewModel.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import SwiftUI
import Combine
import AuthenticationServices

@MainActor
class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fetchPostsUseCase: FetchPostsUseCase
    private let appleLoginUseCase: AppleLoginUseCase
    
    init(fetchPostsUseCase: FetchPostsUseCase, appleLoginUseCase: AppleLoginUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
        self.appleLoginUseCase = appleLoginUseCase
    }
    
    func load() async {
        do {
            self.posts = try await fetchPostsUseCase.execute()
            print("✅ 데이터 로드 성공: \(posts.count)개")
        } catch {
            print(String(describing: error))
        }
    }
    
    func handleAppleLoginResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            
            isLoading = true
            Task {
                do {
                    // UseCase 실행 (팝업이 닫히는 시점에 Supabase 통신 시작)
                    try await appleLoginUseCase.execute(with: credential)
                    print("Zest 로그인 성공")
                } catch {
                    self.errorMessage = error.localizedDescription
                }
                isLoading = false
            }
            
        case .failure(let error):
            // 사용자가 취소한 경우는 에러 메시지를 띄우지 않음
            let authError = error as NSError
            if authError.domain == ASAuthorizationErrorDomain && authError.code == ASAuthorizationError.canceled.rawValue {
                return
            }
            self.errorMessage = error.localizedDescription
        }
    }
}
