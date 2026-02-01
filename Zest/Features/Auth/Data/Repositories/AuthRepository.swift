import Foundation
import AuthenticationServices
import Supabase
import ZestCore

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
    
    func hasSession() async throws -> Session? {
        do {
            let session = try await client.auth.session
            return session
        } catch {
            return nil
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
    
    func saveProfiles(credential: ASAuthorizationAppleIDCredential) async throws {
        // 현재 Supabase Auth 세션에서 사용자 ID 가져오기
        let session = try await client.auth.session
        let userId = session.user.id
        
        // 애플에서 제공하는 사용자 정보
        let email = session.user.email
        let givenName = session.user.userMetadata["full_name"]?.stringValue
        
        
        // profiles 테이블에 사용자 정보 저장 (upsert 방식)
        let profilesData = ProfilesDTO(id: userId, email: email, name: givenName)
        
        try await client
            .from("profiles")
            .upsert(profilesData)
            .execute()
    }
}

