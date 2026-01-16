//
//  PostRepository.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Foundation
import Supabase

struct PostRepository: PostRepositoryProtocol {
    func fetchPosts() async throws -> [Post] {
            // Supabase의 'posts' 테이블에서 데이터 조회
            let response: [PostDTO] = try await APIService.shared
                .from("posts")
                .select()
                .execute()
                .value
            print("✅ Supabase 원본 데이터(DTO): \(response)")
           
            let domainModels = response.map { $0.toDomain() }
            print("✅ 변환된 도메인 데이터(Post): \(domainModels)")
            return domainModels
        }
}
