//
//  CartRepository.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation
import Supabase

final class CartRepository: CartRepositoryProtocol {
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func fetchCartItems(profileId: UUID) async throws -> [CartItem] {
        let response: [CartItemDTO] = try await client
            .from("orders")
            .select()
            .eq("profile_id", value: profileId)
            .execute()
            .value
        
        return response.map { $0.toEntity() }
    }
    
    func addToCart(profileId: UUID, productId: UUID, quantity: Int) async throws {
        let cartItem = CartItemDTO(id: nil, profileId: profileId, productId: productId, quantity: quantity, createdAt: nil)
        
        try await client
            .from("orders")
            .insert(cartItem)
            .execute()
    }
    
    func updateCartItem(id: UUID, quantity: Int) async throws {
        try await client
            .from("orders")
            .update(["quantity": quantity])
            .eq("id", value: id.uuidString)
            .execute()
    }
    
    func removeFromCart(id: UUID) async throws {
        try await client
            .from("orders")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
}
