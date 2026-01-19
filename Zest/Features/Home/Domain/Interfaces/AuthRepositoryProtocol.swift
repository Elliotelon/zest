//
//  AuthRepositoryProtocol.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import AuthenticationServices

protocol AuthRepositoryProtocol {
    /// 애플에서 받은 자격증명(Credential)을 이용해 Supabase 세션을 생성합니다.
    func signInWithSupabase(credential: ASAuthorizationAppleIDCredential) async throws
}


