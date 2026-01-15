//
//  PostRepositoryProtocol.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Foundation

protocol PostRepositoryProtocol {
    func fetchPosts() async throws -> [Post]
}
