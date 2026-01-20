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
        guard let identityToken = credential.identityToken,
              let idTokenString = String(data: identityToken, encoding: .utf8) else {
            throw URLError(.badServerResponse)
        }
        try await client.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: idTokenString)
        )
    }
    
    func checkSession() async throws -> Bool {
        do {
            _ = try await client.auth.session
            return true
        } catch {
            return false
        }
    }
    
    func observeAuthStateChanges(_ onChanged: @escaping (Bool) -> Void) -> Task<Void, Never> {
        Task {
            for await event in client.auth.authStateChanges {
                let isAuthenticated = event.session != nil
                await MainActor.run {
                    onChanged(isAuthenticated)
                }
            }
        }
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
}

