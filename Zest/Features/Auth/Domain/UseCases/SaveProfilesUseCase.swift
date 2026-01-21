//
//  SaveProfilesUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import AuthenticationServices

/// 애플 로그인 후 사용자 정보를 Supabase profiles 테이블에 저장하는 UseCase
final class SaveProfilesUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(with credential: ASAuthorizationAppleIDCredential) async throws {
        try await repository.saveProfiles(credential: credential)
    }
}
