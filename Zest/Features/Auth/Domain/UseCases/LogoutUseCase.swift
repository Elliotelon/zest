//
//  LogoutUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import Foundation

final class LogoutUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.signOut()
    }
}

