//
//  AuthRepositoryProtocol.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import AuthenticationServices

protocol AuthRepositoryProtocol {
    func signInWithSupabase(credential: ASAuthorizationAppleIDCredential) async throws
    func checkSession() async throws -> Bool
    func observeAuthStateChanges(_ onChanged: @escaping (Bool) -> Void) -> Task<Void, Never>
    func signOut() async throws
}

