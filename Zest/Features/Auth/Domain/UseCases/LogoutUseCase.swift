import Foundation

final class LogoutUseCase: Sendable  {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.signOut()
    }
}

