import Foundation
import Supabase

final class GetCurrentSessionUseCase: Sendable  {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> Session? {
        return try await repository.hasSession()
    }
}
