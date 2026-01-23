//
//  Profiles.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

/// 사용자 엔티티
struct Profiles: Codable, Sendable {
    let id: UUID
    let email: String?
    let name: String?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case createdAt = "created_at"
    }
}
