//
//  FetchPostsUseCase.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Foundation

struct FetchPostsUseCase {
    let repository: PostRepositoryProtocol
    
    func execute() async throws -> [Post] {
        try await repository.fetchPosts()
    }
}
