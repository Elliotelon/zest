import AuthenticationServices

final class SaveProfilesUseCase: Sendable  {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(with credential: ASAuthorizationAppleIDCredential) async throws {
        try await repository.saveProfiles(credential: credential)
    }
}
