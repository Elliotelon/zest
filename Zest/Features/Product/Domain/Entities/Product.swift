//
//  Product.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

/// 상품 엔티티
struct Product: Identifiable, Codable {
    let id: UUID
    let name: String
    let price: Double
    let description: String
    let imageUrl: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
