//
//  AppleLoginUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import AuthenticationServices

final class AppleLoginUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(with credential: ASAuthorizationAppleIDCredential) async throws {
        // 비즈니스 로직 수행 후 Repository에 전달
        try await repository.signInWithSupabase(credential: credential)
    }
}

