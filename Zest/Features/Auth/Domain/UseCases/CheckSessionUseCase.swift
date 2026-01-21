//
//  CheckSessionUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import Foundation

final class CheckSessionUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Bool {
        do {
            return try await repository.checkSession()
        } catch {
            return false
        }
    }
}

