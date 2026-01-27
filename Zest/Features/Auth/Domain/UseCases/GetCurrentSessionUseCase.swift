//
//  GetCurrentSessionUseCase.swift
//  Zest
//
//  Created by AI Assistant on 1/21/26.
//

import Foundation
import Supabase

/// 현재 세션 정보를 가져오는 UseCase
final class GetCurrentSessionUseCase: Sendable  {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    /// 현재 세션을 가져옵니다.
    /// - Returns: 현재 활성화된 세션 또는 nil
    func execute() async throws -> Session? {
        return try await repository.hasSession()
    }
}
