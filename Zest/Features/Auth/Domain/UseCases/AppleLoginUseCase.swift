import AuthenticationServices

final class AppleLoginUseCase {
    private let repository: AuthRepositoryProtocol
    private let saveProfilesUseCase: SaveProfilesUseCase

    init(repository: AuthRepositoryProtocol, saveProfilesUseCase: SaveProfilesUseCase) {
        self.repository = repository
        self.saveProfilesUseCase = saveProfilesUseCase
    }

    func execute(with credential: ASAuthorizationAppleIDCredential) async throws {
        // 1. Supabase Auth로 로그인
        try await repository.signInWithSupabase(credential: credential)
      
        // 2. 사용자 정보를 profiles 테이블에 저장
        try await saveProfilesUseCase.execute(with: credential)
  
    }
}

