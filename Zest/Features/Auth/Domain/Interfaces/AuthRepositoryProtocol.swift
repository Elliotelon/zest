//
//  AuthRepositoryProtocol.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import AuthenticationServices
import Supabase

protocol AuthRepositoryProtocol: Sendable {
    func signInWithSupabase(credential: ASAuthorizationAppleIDCredential) async throws
    func checkSession() async throws -> Bool
    func hasSession() async throws -> Session?
    func observeAuthStateChanges(_ onChanged: @escaping (Bool) -> Void) -> Task<Void, Never>
    func signOut() async throws
    
    /// 애플 로그인 후 사용자 정보를 profiles 테이블에 저장합니다.
    func saveProfiles(credential: ASAuthorizationAppleIDCredential) async throws
}

