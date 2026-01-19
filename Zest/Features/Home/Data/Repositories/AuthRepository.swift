//
//  AuthRepository.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import Foundation
import AuthenticationServices
import Supabase

final class AuthRepository: AuthRepositoryProtocol {
    private let client: SupabaseClient

    init(client: SupabaseClient) {
        self.client = client
    }

    func signInWithSupabase(credential: ASAuthorizationAppleIDCredential) async throws {
        // 1. Identity Token 추출
        guard let identityToken = credential.identityToken,
              let idTokenString = String(data: identityToken, encoding: .utf8) else {
            throw URLError(.badServerResponse)
        }
        
        // 2. Supabase Auth 서버에 토큰 전달 (Native SDK 방식)
        try await client.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: idTokenString)
        )
    }
}


