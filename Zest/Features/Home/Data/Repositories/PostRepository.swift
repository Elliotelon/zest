//
//  PostRepository.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Foundation

struct PostRepository: PostRepositoryProtocol {
    func fetchPosts() async throws -> [Post] {
        // 여기에 Env.baseURL을 활용한 통신 코드 작성 예정
        return []
    }
}
