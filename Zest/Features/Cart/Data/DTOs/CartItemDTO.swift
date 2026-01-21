//
//  CartItemDTO.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

struct CartItemDTO: Identifiable, Codable {
    let id: UUID?
    let profileId: UUID
    let productId: UUID
    let quantity: Int
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileId = "profile_id"
        case productId = "product_id"
        case quantity
        case createdAt = "created_at"
    }
    
    /// DTO를 Entity로 변환
    func toEntity() -> CartItem {
        CartItem(
            id: id ?? UUID(),
            profileId: profileId,
            productId: productId,
            quantity: quantity,
            createdAt: createdAt,
        )
    }
}
