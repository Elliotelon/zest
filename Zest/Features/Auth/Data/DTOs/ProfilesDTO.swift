//
//  ProfilesDTO.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

/// 사용자 엔티티
struct ProfilesDTO: Codable {
    let id: UUID
    let email: String?
    let name: String?
}
