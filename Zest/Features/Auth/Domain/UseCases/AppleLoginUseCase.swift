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
        try await repository.signInWithSupabase(credential: credential)
    }
}

