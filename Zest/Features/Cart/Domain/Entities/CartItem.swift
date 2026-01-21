//
//  CartItem.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

/// 장바구니 아이템 엔티티
struct CartItem: Identifiable, Codable {
    let id: UUID
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
}
