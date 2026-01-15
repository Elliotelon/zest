//
//  PostDto.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Foundation

struct PostDTO: Codable {
    let id: Int
    let title: String
    
    func toDomain() -> Post {
        return Post(id: id, title: title)
    }
}
